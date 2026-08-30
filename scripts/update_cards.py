import os
import sys
import json
import requests
from datetime import datetime

# ============================================================================
# CONFIGURATION
# ============================================================================
API_URL = 'https://db.ygoprodeck.com/api/v7/cardinfo.php'
OUTPUT_DIR = 'assets/json'
OUTPUT_FILE = os.path.join(OUTPUT_DIR, 'ygo_api_cache.json')
USER_AGENT = 'YGOBinder/1.0 (https://github.com/TsunaHalo2001/ygobinder)'

# ============================================================================
# MAPPING DICTIONARIES
# Add mappings here to translate codes to full names
# ============================================================================

SET_NAME_MAP = {
    # Example mappings (Add more as you find missing/incorrect set names)
    "LOB": "Legend of Blue Eyes White Dragon",
    "MFC": "Pharaoh's Tour",
    "MP21": "2021 Tin of Ancient Battles",
    "MP22": "2022 Tin of the Pharaoh's Gods",
    "MP23": "25th Anniversary Tin: Dueling Heroes Mega Pack",
    # Add your missing set_code -> set_name mappings here 👇
    "MZTM" : "Maze of the Master",
}

RARITY_NAME_MAP = {
    # Standard YGO Rarity Codes
    "C": "Common",
    "R": "Rare",
    "SR": "Super Rare",
    "UR": "Ultra Rare",
    "ScR": "Secret Rare",
    "CR": "Collector's Rare",
    "PR": "Prismatic Secret Rare",
    "HR": "Holographic Rare",
    "UtR": "Ultimate Rare",
    "GR": "Ghost Rare",
    "QC": "Quarter Century Secret Rare",
    "PG": "Platinum Ghost Rare",
    "SP": "Starlight Rare",
    "SER": "Secret Rare", # Sometimes APIs mix up ScR and SER
    "PSER": "Prismatic Secret Rare",
    # Add your missing set_rarity_code -> set_rarity mappings here 👇
}

# ============================================================================
# MANUAL CORRECTIONS
# Format: card_id: [ list of { 'set_code': '...', 'set_rarity_code': '...' } ]
# ============================================================================
MANUAL_CORRECTIONS = {
    # Example 1: Fix the rarity code for a specific set on a specific card
    # 89631139: [  # Blue-Eyes White Dragon
    #     {
    #         "set_code": "LOB",
    #         "set_rarity_code": "UR"  # Will map to "Ultra Rare" via RARITY_NAME_MAP
    #     }
    # ],
    
    # Example 2: Add a missing set to a card entirely
    # 12345678: [
    #     {
    #         "set_code": "MP21",      # Will map to "2021 Tin of Ancient Battles" via SET_NAME_MAP
    #         "set_rarity_code": "ScR" # Will map to "Secret Rare"
    #     }
    # ],

    # Add your corrections here 👇
    33744268: [
        {
            "set_code": "MZTM",
            "set_rarity_code": "R"
        }
    ]
}

# ============================================================================
# CORE FUNCTIONS
# ============================================================================

def fetch_card_data():
    """Fetches card data from the YGOProDeck API."""
    print("🔍 Fetching data from YGOProDeck API...")
    headers = {'User-Agent': USER_AGENT}
    
    try:
        response = requests.get(API_URL, headers=headers, timeout=120) # Increased timeout for large payload
        response.raise_for_status()
        return response.json()
    except requests.exceptions.RequestException as e:
        print(f"❌ Failed to fetch data: {e}")
        sys.exit(1)

def apply_manual_corrections(card_data):
    """Applies manual corrections using code mappings."""
    if not MANUAL_CORRECTIONS:
        print("ℹ️  No manual corrections to apply.")
        return card_data, []
    
    print(f"⚙️  Applying {len(MANUAL_CORRECTIONS)} manual correction profile(s)...")
    corrections_applied = []
    
    cards_list = card_data.get('data', [])
    cards_dict = {card['id']: card for card in cards_list}
    
    for card_id, corrections_list in MANUAL_CORRECTIONS.items():
        if card_id not in cards_dict:
            print(f"  ⚠️  Warning: Card ID {card_id} not found in API data. Skipping.")
            continue
        
        card = cards_dict[card_id]
        card_name = card.get('name', 'Unknown Card')
        card_sets = card.setdefault('card_sets', []) # Ensure card_sets exists
        
        correction_log = {
            'card_id': card_id, 
            'card_name': card_name, 
            'changes': []
        }
        
        for correction in corrections_list:
            target_set_code = correction.get('set_code')
            target_rarity_code = correction.get('set_rarity_code')
            
            # Look for existing set in the card's data
            existing_set = next((s for s in card_sets if s.get('set_code') == target_set_code), None)
            
            # Determine the correct full names from our maps (fallback to existing or 'Unknown')
            correct_set_name = SET_NAME_MAP.get(target_set_code, target_set_code) # Fallback to code if not in map
            correct_rarity = RARITY_NAME_MAP.get(target_rarity_code, target_rarity_code)
            
            if existing_set:
                # UPDATE existing set
                changes_made = False
                
                if existing_set.get('set_name') != correct_set_name:
                    correction_log['changes'].append(f"set_name: '{existing_set.get('set_name')}' → '{correct_set_name}'")
                    existing_set['set_name'] = correct_set_name
                    changes_made = True
                    
                if existing_set.get('set_rarity') != correct_rarity:
                    correction_log['changes'].append(f"set_rarity: '{existing_set.get('set_rarity')}' → '{correct_rarity}'")
                    existing_set['set_rarity'] = correct_rarity
                    changes_made = True
                    
                if existing_set.get('set_rarity_code') != target_rarity_code:
                    correction_log['changes'].append(f"set_rarity_code: '{existing_set.get('set_rarity_code')}' → '{target_rarity_code}'")
                    existing_set['set_rarity_code'] = target_rarity_code
                    changes_made = True
                
                # Always enforce set_price to 0 (or 0.0) for corrected entries if desired
                if existing_set.get('set_price') != 0:
                    correction_log['changes'].append(f"set_price: '{existing_set.get('set_price')}' → 0")
                    existing_set['set_price'] = 0
                    changes_made = True
                    
                if changes_made:
                    print(f"  ✅ Updated '{card_name}' (Set: {target_set_code})")
                    
            else:
                # ADD new set entry (handles missing set_code scenario)
                new_set_entry = {
                    "set_name": correct_set_name,
                    "set_code": target_set_code,
                    "set_rarity": correct_rarity,
                    "set_rarity_code": target_rarity_code,
                    "set_price": 0
                }
                card_sets.append(new_set_entry)
                correction_log['changes'].append(f"ADDED new set: {target_set_code} ({correct_rarity})")
                print(f"  ➕ Added missing set '{target_set_code}' to '{card_name}'")
        
        if correction_log['changes']:
            corrections_applied.append(correction_log)
            
    return card_data, corrections_applied

def save_data(data):
    """Saves the data to the JSON file."""
    print(f"💾 Saving data to {OUTPUT_FILE}...")
    os.makedirs(OUTPUT_DIR, exist_ok=True)
    
    with open(OUTPUT_FILE, 'w', encoding='utf-8') as f:
        json.dump(data, f, ensure_ascii=False, indent=2)
    
    print("✅ Data saved successfully!")

def save_corrections_log(corrections):
    """Saves a log of applied corrections for debugging."""
    if not corrections:
        return
    
    log_file = os.path.join(OUTPUT_DIR, 'corrections_log.json')
    log_data = {
        'timestamp': datetime.now().isoformat(),
        'total_corrections': len(corrections),
        'corrections': corrections
    }
    
    with open(log_file, 'w', encoding='utf-8') as f:
        json.dump(log_data, f, ensure_ascii=False, indent=2)

def main():
    print(f"🚀 Starting card update process at {datetime.now().strftime('%Y-%m-%d %H:%M:%S')}")
    print("=" * 70)
    
    # 1. Fetch
    card_data = fetch_card_data()
    print(f"📦 Fetched {len(card_data.get('data', []))} cards from API")
    print("=" * 70)
    
    # 2. Correct
    card_data, corrections = apply_manual_corrections(card_data)
    print("=" * 70)
    
    # 3. Save
    save_data(card_data)
    save_corrections_log(corrections)
    
    print("=" * 70)
    print(f"🎉 Update process completed successfully!")
    print(f"   Manual corrections applied: {len(corrections)}")

if __name__ == '__main__':
    main()