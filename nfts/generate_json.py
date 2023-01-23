import os
import json
import random

# JSON format
JSON_FORMAT = '{"name": "<name>","description": "<name> <description>","image": "ipfs://<images_cid>/<name>.png","attributes": [{"name":"rarity","value": "<random>"}]}'

IMAGE_CID=""
DESCRIPTION = "free diving"

# Assign directory
current_dir = os.path.dirname(os.path.abspath(__file__))
png_directory = f'{current_dir}/png'
json_directory = f'{current_dir}/json'


# Iterate over pngs and create json file
for filename in os.listdir(png_directory):
        json_string = JSON_FORMAT
        size = len(filename)
        name = filename[:size - 4]
        json_string = json_string.replace("<name>", name)
        json_string = json_string.replace("<description>", DESCRIPTION)
        json_string = json_string.replace("<images_cid>", IMAGE_CID)
        json_string = json_string.replace("<random>", str(random.randint(1,10)))
        with open(f'{json_directory}/{name}.json', 'w') as json_file:
            json_file.write(json_string)