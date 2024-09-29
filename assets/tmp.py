import json
from openai import OpenAI
import numpy as np
from sklearn.cluster import KMeans
from sklearn.preprocessing import normalize
import logging
from tqdm import tqdm
import time

# Configure logging
logging.basicConfig(level=logging.INFO, format='%(asctime)s - %(levelname)s - %(message)s')

# Replace with your OpenAI API key
client = OpenAI(api_key='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')

class Video:
    def __init__(self, title, imagePath, duration, videoPath, summary):
        self.title = title
        self.imagePath = imagePath
        self.duration = duration
        self.videoPath = videoPath
        self.summary = summary

    def to_dict(self):
        return {
            "title": self.title,
            "imagePath": self.imagePath,
            "duration": self.duration,
            "videoPath": self.videoPath,
            "summary": self.summary
        }

def parse_videos(json_list):
    videos = []
    for item in json_list:
        title = item.get("title", "")
        summary = item.get("description", "")
        duration = item.get("duration_string", "")
        imagePath = item.get("thumbnails", [{}])[0].get("url", "")
        videoPath = item.get("url", "")
        video = Video(title, imagePath, duration, videoPath, summary)
        videos.append(video)
    logging.info(f"Parsed {len(videos)} videos from JSON")
    return videos

def get_embeddings(text_list, batch_size=100):
    embeddings = []
    for i in tqdm(range(0, len(text_list), batch_size), desc="Processing Embeddings"):
        batch = text_list[i:i + batch_size]
        try:
            response = client.embeddings.create(input=batch, model="text-embedding-ada-002")
            batch_embeddings = [data.embedding for data in response.data]
            embeddings.extend(batch_embeddings)
        except Exception as e:
            logging.error(f"Error getting embeddings: {e}")
            raise
    logging.info(f"Received embeddings for {len(text_list)} texts")
    return np.array(embeddings)

def cluster_videos(videos, num_clusters=5):
    texts = [video.title + " " + (video.summary or "") for video in videos]
    embeddings = get_embeddings(texts)
    normalized_embeddings = normalize(embeddings)
    kmeans = KMeans(n_clusters=num_clusters, random_state=42)
    kmeans.fit(normalized_embeddings)
    logging.info(f"Clustered videos into {num_clusters} clusters")
    return kmeans.labels_

def generate_category_names(cluster_texts, max_texts_per_batch=20):
    category_names = []
    for texts in cluster_texts:
        # Pick up to 20 texts from the cluster
        batch = texts[:max_texts_per_batch]
        prompt = "Check the below titles and descriptions , Generate a good category name that covers the list of video titles and descriptions:\n\n"
        prompt += "\n".join(batch)
        try:
            response = client.chat.completions.create(
                model="gpt-4",
                messages=[
                    {"role": "system", "content": "You are a helpful assistant."},
                    {"role": "user", "content": prompt}
                ],
                max_tokens=100
            )
            time.sleep(10)

            category_name = response['choices'][0]['message']['content'].strip()
            category_names.append(category_name)
        except Exception as e:
            logging.error(f"Error generating category names: {e}")
            category_names.append("Unknown")
    return category_names

def name_clusters(videos, labels, num_clusters):
    cluster_texts = [[] for _ in range(num_clusters)]
    for idx, video in enumerate(videos):
        cluster = labels[idx]
        cluster_texts[cluster].append(video.title + " " + (video.summary or ""))
    cluster_names = generate_category_names(cluster_texts)
    logging.info(f"Named clusters: {cluster_names}")
    return {i: name for i, name in enumerate(cluster_names)}

def categorize_videos(videos, labels, cluster_names):
    categorized_videos = {}
    for idx, video in enumerate(videos):
        cluster = labels[idx]
        cluster_name = cluster_names[cluster]
        if cluster_name not in categorized_videos:
            categorized_videos[cluster_name] = []
        categorized_videos[cluster_name].append(video.to_dict())
    logging.info("Categorized videos into clusters")
    return categorized_videos

def save_to_json(categorized_videos, output_file):
    try:
        with open(output_file, 'w') as f:
            json.dump({"categories": categorized_videos}, f, indent=4)
        logging.info(f"Categorized videos saved to {output_file}")
    except Exception as e:
        logging.error(f"Error saving JSON file: {e}")
        raise

def main(input_file, output_file):
    try:
        with open(input_file, 'r') as file:
            json_list = json.load(file)
        logging.info(f"Loaded JSON from {input_file}")
        videos = parse_videos(json_list)
        labels = cluster_videos(videos)
        cluster_names = name_clusters(videos, labels, 5)
        categorized_videos = categorize_videos(videos, labels, cluster_names)
        save_to_json(categorized_videos, output_file)
    except Exception as e:
        logging.error(f"Error in main process: {e}")

# Example usage
input_file = 'channel_videos.json'
output_file = 'categorized_videos.json'
main(input_file, output_file)
