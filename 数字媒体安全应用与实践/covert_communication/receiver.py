from pathlib import Path

import requests

from image import extract_watermark


def download_file(url):
    local_filename = url.split('/')[-1]
    with requests.get(url, stream=True) as r:
        r.raise_for_status()
        with open(local_filename, 'wb') as f:
            for chunk in r.iter_content(chunk_size=8192):
                if chunk:  # filter out keep-alive new chunks
                    f.write(chunk)
                    # f.flush()
    return local_filename


def get_post(url):
    s = requests.session()

    r = s.get(url + '/api/posts')

    posts = r.json()['results']

    for post in posts:
        image_file = download_file(url + '/images/' + post['image'])
        extract_watermark(image_file)


if __name__ == '__main__':
    url = 'http://127.0.0.1:5000'

    get_post(url)