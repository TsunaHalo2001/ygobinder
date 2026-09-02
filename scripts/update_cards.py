import os
import sys
import json
import requests
from datetime import datetime

# ============================================================================
# CONFIGURATION
# ============================================================================
API_URL = 'https://db.ygoprodeck.com/api/v7/cardinfo.php?misc=yes'
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
    "(C)": "Common",
    "(R)": "Rare",
    "(SR)": "Super Rare",
    "(UR)": "Ultra Rare",
    "(ScR)": "Secret Rare",
    "(CR)": "Collector's Rare",
    "(PR)": "Prismatic Secret Rare",
    "(HR)": "Holographic Rare",
    "(UtR)": "Ultimate Rare",
    "(GR)": "Ghost Rare",
    "(QC)": "Quarter Century Secret Rare",
    "(PG)": "Platinum Ghost Rare",
    "(SP)": "Starlight Rare",
    "(SER)": "Secret Rare", # Sometimes APIs mix up ScR and SER
    "(PSER)": "Prismatic Secret Rare",
    # Add your missing set_rarity_code -> set_rarity mappings here 👇
}

# ============================================================================
# ID CORRECTIONS
# Format: wrong_api_id: correct_id
# This runs FIRST so all other corrections use the correct ID.
# ============================================================================
ID_CORRECTIONS = {
    # Example: The API incorrectly lists this card as 8131171, but its real ID is 46986414
    # 8131171: 46986414, 
    
    # Add your ID corrections here 👇
    48739627: 74733322,
    74733322: 48739627,
    1122030: 37517035,
    37517035: 1122030,
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
            "set_code": "MZTM-EN020",
            "set_rarity_code": "(R)"
        }
    ],

    26585784: [
        {
            "set_code": "JUSH-EN041",
            "set_rarity_code": "(R)"
        }
    ],

    79625003: [
        {
            "set_code": "BLMM-EN037",
            "set_rarity_code": "(UR)"
        }
    ],

    16110708: [
        {
            "set_code": "BLMM-EN038",
            "set_rarity_code": "(UR)"
        }
    ],

    94292987: [
        {
            "set_code": "BLMM-EN013",
            "set_rarity_code": "(UR)"
        }
    ],

    68897338: [
        {
            "set_code": "BLMM-EN012",
            "set_rarity_code": "(UR)"
        }
    ],

    93170499: [
        {
            "set_code": "BLMM-EN016",
            "set_rarity_code": "(UR)"
        }
    ],

    20568404: [
        {
            "set_code": "BLMM-EN017",
            "set_rarity_code": "(UR)"
        }
    ],

    80447641: [
        {
            "set_code": "BLMM-EN034",
            "set_rarity_code": "(UR)"
        }
    ],

    42382265: [
        {
            "set_code": "BLMM-EN042",
            "set_rarity_code": "(UR)"
        }
    ],

    74387963: [
        {
            "set_code": "BLMM-EN043",
            "set_rarity_code": "(UR)"
        }
    ],

    57775790: [
        {
            "set_code": "BLMM-EN015",
            "set_rarity_code": "(UR)"
        }
    ],

    50596425: [
        {
            "set_code": "BLMM-EN027",
            "set_rarity_code": "(UR)"
        }
    ],

    44459942: [
        {
            "set_code": "BLMM-EN029",
            "set_rarity_code": "(UR)"
        }
    ],

    88477149: [
        {
            "set_code": "BLMM-EN032",
            "set_rarity_code": "(UR)"
        }
    ],

    43236494: [
        {
            "set_code": "BLMM-EN036",
            "set_rarity_code": "(UR)"
        }
    ],

    42104806: [
        {
            "set_code": "BLMM-EN039",
            "set_rarity_code": "(UR)"
        }
    ],

    59080: [
        {
            "set_code": "BLMM-EN047",
            "set_rarity_code": "(UR)"
        }
    ],

    91019775: [
        {
            "set_code": "BLMM-EN030",
            "set_rarity_code": "(UR)"
        }
    ],

    44376395: [
        {
            "set_code": "DUAD-EN085",
            "set_rarity_code": "(C)"
        }
    ],

    49451215: [
        {
            "set_code": "DUAD-EN051",
            "set_rarity_code": "(C)"
        }
    ],

    70659412: [
        {
            "set_code": "DUAD-EN089",
            "set_rarity_code": "(C)"
        }
    ],

    18988396: [
        {
            "set_code": "DUAD-EN084",
            "set_rarity_code": "(C)"
        }
    ],

    336601: [
        {
            "set_code": "DUAD-EN100",
            "set_rarity_code": "(C)"
        }
    ],

    74941992: [
        {
            "set_code": "DUAD-EN099",
            "set_rarity_code": "(C)"
        }
    ],

    19316241: [
        {
            "set_code": "DUAD-EN097",
            "set_rarity_code": "(SR)"
        }
    ],

    7166709: [
        {
            "set_code": "DUAD-EN087",
            "set_rarity_code": "(C)"
        }
    ],

    60600821: [
        {
            "set_code": "DUAD-EN073",
            "set_rarity_code": "(C)"
        }
    ],

    97227123: [
        {
            "set_code": "DUAD-EN071",
            "set_rarity_code": "(C)"
        }
    ],

    98349765: [
        {
            "set_code": "DUAD-EN068",
            "set_rarity_code": "(C)"
        }
    ],

    61944066: [
        {
            "set_code": "DUAD-EN067",
            "set_rarity_code": "(C)"
        }
    ],

    36494597: [
        {
            "set_code": "DUAD-EN060",
            "set_rarity_code": "(C)"
        }
    ],

    1122030: [
        {
            "set_code": "DUAD-EN056",
            "set_rarity_code": "(C)"
        }
    ],

    74733322: [
        {
            "set_code": "DUAD-EN055",
            "set_rarity_code": "(C)"
        }
    ],

    85150300: [
        {
            "set_code": "DUAD-EN080",
            "set_rarity_code": "(C)"
        }
    ],

    58761791: [
        {
            "set_code": "DUAD-EN079",
            "set_rarity_code": "(C)"
        }
    ],

    95382988: [
        {
            "set_code": "DUAD-EN077",
            "set_rarity_code": "(C)"
        }
    ],

    23599634: [
        {
            "set_code": "DUAD-EN075",
            "set_rarity_code": "(C)"
        }
    ],

    87640391: [
        {
            "set_code": "ALIN-EN099",
            "set_rarity_code": "(C)"
        }
    ],

    8240199: [
        {
            "set_code": "SDWD-EN013",
            "set_rarity_code": "(C)"
        }
    ],

    66961194: [
        {
            "set_code": "SDWD-EN015",
            "set_rarity_code": "(C)"
        }
    ],

    97268402: [
        {
            "set_code": "SDWD-EN018",
            "set_rarity_code": "(C)"
        }
    ],

    71143015: [
        {
            "set_code": "SDWD-EN021",
            "set_rarity_code": "(C)"
        }
    ],

    48800175: [
        {
            "set_code": "SDWD-EN022",
            "set_rarity_code": "(C)"
        }
    ],

    38120068: [
        {
            "set_code": "SDWD-EN025",
            "set_rarity_code": "(C)"
        }
    ],
}

# ============================================================================
# EDISON FORMAT CONFIGURATION
# ============================================================================
EDISON_CUTOFF_DATE = "2010-04-20" # Duelist Pack: Kaiba release date

# Manual overrides for the Edison Banlist.
# Use "0" for Forbidden, "1" for Limited, "2" for Semi-Limited, or "3" to force legal.
EDISON_BANLIST_OVERRIDES = {
    # Example: 
    # 46986414: "1",  # Dark Magician (Limited)
    # 89631139: "0",  # Blue-Eyes White Dragon (Forbidden)
    
    # Add your Edison banlist overrides here 👇
    # Prohibited
    72989439: "0", # Black Luster Soldier - Envoy of the Beginning
    82301904: "0", # Chaos Emperor Dragon - Envoy of the End
    34124316: "0", # Cyber Jar
    69015963: "0", # Cyber-Stein
    40737112: "0", # Dark Magician of Chaos
    56570271: "0", # Destiny HERO - Disk Commander
    78706415: "0", # Fiber Jar
    34206604: "0", # Magical Scientist
    31560081: "0", # Magician of Faith
    21593977: "0", # Makyura the Destructor
    8131171: "0", # Sinister Serpent
    33184167: "0", # Tribe-Infecting Virus
    34853266: "0", # Tsukuyomi
    44910027: "0", # Victory Dragon
    78010363: "0", # Witch of the Black Forest
    3078576: "0", # Yata-Garasu
    69243953: "0", # Butterfly Dagger - Elma
    57953380: "0", # Card Of Safe Return
    4031928: "0", # Change of Heart
    17375316: "0", # Confiscation
    53129443: "0", # Dark Hole
    44763025: "0", # Delinquent Duo
    23557835: "0", # Dimension Fusion
    79571449: "0", # Graceful Charity
    18144506: "0", # Harpie's Feather Duster
    85602018: "0", # Last Will
    46411259: "0", # Metamorphosis
    41482598: "0", # Mirage of Nightmare
    83764718: "0", # Monster Reborn
    74191942: "0", # Painful Choice
    55144522: "0", # Pot of Greed
    70828912: "0", # Premature Burial
    12580477: "0", # Raigeki
    45986603: "0", # Snatch Steal
    42829885: "0", # The Forceful Sentry
    57728570: "0", # Crush Card Virus
    17484499: "0", # Exchange of the Spirit
    61740673: "0", # Imperial Order
    28566710: "0", # Last Turn
    83555666: "0", # Ring of Destruction
    35316708: "0", # Time Seal
    32646477: "0", # Dark Strike Fighter
    63519819: "0", # Thousand-Eyes Restrict

    # Limited
    2009101: "1", # Blackwing - Gale the Whirlwind
    85087012: "1", # Card Trooper
    9596126: "1", # Chaos Sorcerer
    65192027: "1", # Dark Armed Dragon
    40044918: "1", # Elemental HERO Stratos
    33396948: "1", # Exodia the Forbidden One
    41470137: "1", # Gladiator Beast Bestiari
    44330098: "1", # Gorz the Emissary of Darkness
    7902349: "1", # Left Arm of the Forbidden One
    44519536: "1", # Left Leg of the Forbidden One
    95503687: "1", # Lumina, Lightsworn Summoner
    31305911: "1", # Marshmallon
    92826944: "1", # Mezuki
    96782886: "1", # Mind Master
    33508719: "1", # Morphing Jar
    28297833: "1", # Necroface
    4906301: "1", # Necro Gardna
    80344569: "1", # Neo-Spacian Grand Mole
    16226786: "1", # Night Assailant
    33420078: "1", # Plaguespreader Zombie
    14878871: "1", # Rescue Cat
    70903634: "1", # Right Arm of the Forbidden One
    8124921: "1", # Right Leg of the Forbidden One
    26202165: "1", # Sangan
    84290642: "1", # Snipe Hunter
    23205979: "1", # Spirit Reaper
    423585: "1", # Summoner Monk
    98777036: "1", # Tragoedia
    46052429: "1", # Advanced Ritual Art
    1475311: "1", # Allure of Darkness
    87910978: "1", # Brain Control
    48976825: "1", # Burial from a Different Dimension
    72892473: "1", # Card Destruction
    94886282: "1", # Charge of the Light Brigade
    60682203: "1", # Cold Wave
    45809008: "1", # Destiny Draw
    67723438: "1", # Emergency Teleport
    81439173: "1", # Foolish Burial
    77565204: "1", # Future Fusion
    42703248: "1", # Giant Trunade
    19613556: "1", # Heavy Storm
    3136426: "1", # Level Limit - Area B
    23171610: "1", # Limiter Removal
    23171610: "1", # Megamorph
    37520316: "1", # Mind Control
    43040603: "1", # Monster Gate
    5318639: "1", # Mystical Space Typhoon
    2295440: "1", # One for One
    3659803: "1", # Overload Fusion
    58577036: "1", # Reasoning
    32807846: "1", # Reinforcement of the Army
    73915051: "1", # Scapegoat
    72302403: "1", # Sword of Revealing Light
    97077563: "1", # Call of the Haunted
    36468556: "1", # Ceasefire
    85742772: "1", # Gravity Bind
    62279055: "1", # Magic Cylinder
    32723153: "1", # Magical Explosion
    15800838: "1", # Mind Crush
    44095762: "1", # Mirror Force
    29843091: "1", # Ojama Trio
    27174286: "1", # Return from the Different Dimension
    41420027: "1", # Solemn Judgment
    46652477: "1", # The Transmigration Prophecy
    53582587: "1", # Torrential Tribute
    64697231: "1", # Trap Dustshoot
    17078030: "1", # Wall of Revealing Light
    73580471: "1", # Black Rose Dragon
    50321796: "1", # Brionac, Dragon of the Ice Barrier
    7391448: "1", # Goyo Guardian

    # Semi-Limited
    70095154: "2", # Cyber Dragon
    15341821: "2", # Dandylion
    72426662: "2", # Demise, King of Armageddon
    9411399: "2", # Destiny HERO - Malicious
    63665875: "2", # Goblin Zombie
    37742478: "2", # Honest
    57774843: "2", # Judgment Dragon
    48686504: "2", # Lonefire Blossom
    12538374: "2", # Treeborn Frog
    91351370: "2", # Black Whirlwind
    91623717: "2", # Chain Strike
    75500286: "2", # Gold Sarcophagus
    98494543: "2", # Magical Stone Excavation
    56747793: "2", # United We Stand
    29401950: "2", # Bottomless Trap Hole
    51452091: "2", # Royal Decree
    93016201: "2", # Royal Oppression
    82732705: "2", # Skill Drain
    80604091: "2", # Ultimate Offering
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

def get_set_name(code):
    """Resolves a set code to its full name, supporting prefix matching (e.g., MZTM-EN020 -> MZTM)."""
    # 1. Check for exact match first
    if code in SET_NAME_MAP:
        return SET_NAME_MAP[code]
    
    # 2. Check for prefix match (e.g., "MZTM-EN020" becomes "MZTM")
    prefix = code.split('-')[0]
    if prefix in SET_NAME_MAP:
        return SET_NAME_MAP[prefix]
    
    # 3. Fallback to the code itself if not found in the map
    return code

def apply_id_corrections(card_data):
    """Fixes incorrect card IDs from the API before other corrections run."""
    if not ID_CORRECTIONS:
        print("ℹ️  No ID corrections to apply.")
        return card_data

    print(f" Applying {len(ID_CORRECTIONS)} ID correction(s)...")
    id_fix_count = 0

    for card in card_data.get('data', []):
        old_id = card.get('id')
        
        # If this card has a known wrong ID, fix it
        if old_id in ID_CORRECTIONS:
            new_id = ID_CORRECTIONS[old_id]
            card['id'] = new_id
            id_fix_count += 1
            print(f"  ✅ Fixed ID for '{card.get('name')}': {old_id} → {new_id}")

    print(f"   🔄 Total IDs corrected: {id_fix_count}")
    return card_data

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
            print(f"  ️  Warning: Card ID {card_id} not found in API data. Skipping.")
            continue
        
        card = cards_dict[card_id]
        card_name = card.get('name', 'Unknown Card')
        card_sets = card.setdefault('card_sets', [])
        
        correction_log = {
            'card_id': card_id, 
            'card_name': card_name, 
            'changes': []
        }
        
        for correction in corrections_list:
            target_set_code = correction.get('set_code')
            target_rarity_code = correction.get('set_rarity_code')
            
            # Resolve the full name using our new helper
            correct_set_name = get_set_name(target_set_code)
            correct_rarity = RARITY_NAME_MAP.get(target_rarity_code, target_rarity_code)
            
            # FIX: Look for existing set matching EITHER the exact code OR the prefix
            target_prefix = target_set_code.split('-')[0]
            existing_set = next((s for s in card_sets if s.get('set_code') == target_set_code or s.get('set_code') == target_prefix), None)
            
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
                
                # Force set_price to 0
                if existing_set.get('set_price') != 0:
                    correction_log['changes'].append(f"set_price: '{existing_set.get('set_price')}' → 0")
                    existing_set['set_price'] = 0
                    changes_made = True
                    
                if changes_made:
                    print(f"  ✅ Updated '{card_name}' (Set: {target_set_code})")
                    
            else:
                # ADD new set entry
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

def clean_misc_info(card_data):
    """Filters misc_info to only keep tcg_date and ocg_date to save space."""
    print(" Cleaning misc_info data...")
    kept_count = 0
    
    for card in card_data.get('data', []):
        misc_list = card.get('misc_info')
        
        # Ensure misc_info exists and is a list
        if isinstance(misc_list, list):
            filtered_misc = []
            
            for info in misc_list:
                if isinstance(info, dict):
                    # Create a new dictionary with ONLY the fields we want
                    cleaned_info = {
                        k: info[k] for k in ('tcg_date', 'ocg_date') if k in info
                    }
                    
                    # Only add it if it actually contains a date
                    if cleaned_info:
                        filtered_misc.append(cleaned_info)
            
            # Replace the heavy original list with our lightweight list
            card['misc_info'] = filtered_misc
            
            if filtered_misc:
                kept_count += 1
                
    print(f"   Kept dates for {kept_count} cards.")
    return card_data

def apply_edison_banlist(card_data):
    """
    Adds 'ban_edison' to banlist_info. 
    Sets it to '3' if the card's TCG release date is on or before the Edison cutoff.
    Applies manual overrides from EDISON_BANLIST_OVERRIDES.
    """
    print("⚔️  Applying Edison Format banlist logic...")
    legal_count = 0
    override_count = 0
    
    for card in card_data.get('data', []):
        card_id = card.get('id')
        
        # 1. Ensure banlist_info exists as a dictionary
        if 'banlist_info' not in card or not isinstance(card['banlist_info'], dict):
            card['banlist_info'] = {}
            
        banlist = card['banlist_info']
        
        # 2. Remove 'ban_edison' by default (in case it was there from a previous run)
        banlist.pop('ban_edison', None)
        
        # 3. Find the card's TCG release date (located in misc_info)
        tcg_date = None
        if card.get('misc_info') and isinstance(card['misc_info'], list) and len(card['misc_info']) > 0:
            tcg_date = card['misc_info'][0].get('tcg_date')
            
        # 4. Check if the card is legally in the Edison card pool
        is_edison_legal = tcg_date and tcg_date <= EDISON_CUTOFF_DATE
        
        if is_edison_legal:
            banlist['ban_edison'] = "3"
            legal_count += 1
            
        # 5. Apply manual overrides (This overrides the "3" or adds it if missing)
        if card_id in EDISON_BANLIST_OVERRIDES:
            banlist['ban_edison'] = str(EDISON_BANLIST_OVERRIDES[card_id])
            override_count += 1
            
    print(f"   ✅ Marked {legal_count} cards as Edison Legal ('3').")
    print(f"   ⚙️  Applied {override_count} manual banlist overrides.")
    
    return card_data

def main():
    print(f"🚀 Starting card update process at {datetime.now().strftime('%Y-%m-%d %H:%M:%S')}")
    print("=" * 70)
    
    # 1. Fetch data from API
    card_data = fetch_card_data()
    print(f"📦 Fetched {len(card_data.get('data', []))} cards from API")
    print("=" * 70)
    
    # 2. Fix IDs FIRST (So subsequent steps use the correct IDs)
    card_data = apply_id_corrections(card_data)
    print("=" * 70)
    
    # 3. Apply manual corrections (Sets/Rarities)
    card_data, corrections = apply_manual_corrections(card_data)
    print("=" * 70)
    
    # 4. Clean misc_info (Keep only dates)
    card_data = clean_misc_info(card_data)
    print("=" * 70)
    
    # 5. Apply Edison Banlist Logic
    card_data = apply_edison_banlist(card_data)
    print("=" * 70)
    
    # 6. Save the corrected and cleaned data
    save_data(card_data)
    save_corrections_log(corrections)
    
    print("=" * 70)
    print(f"🎉 Update process completed successfully!")
    print(f"   Manual corrections applied: {len(corrections)}")

if __name__ == '__main__':
    main()