import pickle
import functions_framework
from google.cloud import storage
from flask import jsonify, request
import json
import numpy as np

class NpEncoder(json.JSONEncoder):
    def default(self, obj):
        if isinstance(obj, np.integer):
            return int(obj)
        if isinstance(obj, np.floating):
            return float(obj)
        if isinstance(obj, np.ndarray):
            return obj.tolist()
        return super(NpEncoder, self).default(obj)

def load_tracks_from_file(file_path):
    with open(file_path, 'rb') as f:
        tracks = pickle.load(f)
    return tracks

def get_player_by_frame_and_point(frame_num, point, tracks):
    if frame_num < 0 or frame_num >= len(tracks['players']):
        return None

    x, y = point

    for player_id, track in tracks['players'][frame_num].items():
        bbox = track['bbox']
        x1, y1, x2, y2 = bbox

        if x1 <= x <= x2 and y1 <= y <= y2:
            return track

    return None

@functions_framework.http
def get_player(request):
    request_json = request.get_json()
    if not request_json:
        return jsonify({'error': 'Invalid request, JSON body required'}), 400

    frame_num = request_json.get('frame_num')
    point = request_json.get('point')

    if frame_num is None or point is None:
        return jsonify({'error': 'Missing required parameters'}), 400

    storage_client = storage.Client()
    bucket_name = 'deeeelin_storage'
    bucket = storage_client.bucket(bucket_name)
    blob = bucket.blob('saved_tracks.pkl')

    local_tmp_path = '/tmp/saved_tracks.pkl'
    blob.download_to_filename(local_tmp_path)
    tracks = load_tracks_from_file(local_tmp_path)

    player = get_player_by_frame_and_point(frame_num, point, tracks)

    if player:
        return json.dumps(player, cls=NpEncoder)
    else:
        return jsonify({'error': 'Player not found'}), 404
