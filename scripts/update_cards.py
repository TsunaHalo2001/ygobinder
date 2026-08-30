import os
import sys
import json
import requests
from datetime import datetime

# Configuration
API_URL = 'https://db.ygoprodeck.com/api/v7/cardinfo.php'
OUTPUT_DIR = 'assets/json'
OUTPUT_FILE = os.path.join(OUTPUT_DIR, 'ygo_api_cache.json')
USER_AGENT = 'YGOBinder/1.0 (https://github.com/TsunaHalo2001/ygobinder)'

def fetch_card_data():
    """Fetches card data from the YGOProDeck API."""
    print("🔍 Fetching data from YGOProDeck API...")
    headers = {'User-Agent': USER_AGENT}
    
    try:
        response = requests.get(API_URL, headers=headers, timeout=60)
        response.raise_for_status()  # Raise an error for bad status codes (4xx or 5xx)
        return response.json()
    except requests.exceptions.RequestException as e:
        print(f"❌ Failed to fetch data: {e}")
        sys.exit(1)

def save_data(data):
    """Saves the data to the JSON file."""
    print(f"💾 Saving data to {OUTPUT_FILE}...")
    
    # Ensure the directory exists
    os.makedirs(OUTPUT_DIR, exist_ok=True)
    
    with open(OUTPUT_FILE, 'w', encoding='utf-8') as f:
        # indent=2 makes it readable, ensure_ascii=False preserves special characters
        json.dump(data, f, ensure_ascii=False, indent=2)
    
    print("✅ Data saved successfully!")

def main():
    print(f"🚀 Starting card update process at {datetime.now().strftime('%Y-%m-%d %H:%M:%S')}")
    
    # 1. Fetch
    data = fetch_card_data()
    
    # TODO: Add future expansions here! 
    # Example: Filter out "Skill Cards" or "Tokens" before saving
    # data['data'] = [card for card in data['data'] if card.get('type') != 'Skill Card']
    
    # 2. Save
    save_data(data)
    
    print("🎉 Update process completed successfully.")

if __name__ == '__main__':
    main()