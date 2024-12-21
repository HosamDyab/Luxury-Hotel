import os
import requests
from pathlib import Path

def download_file(url, destination):
    response = requests.get(url)
    response.raise_for_status()
    
    os.makedirs(os.path.dirname(destination), exist_ok=True)
    
    with open(destination, 'wb') as f:
        f.write(response.content)
    print(f"Downloaded: {destination}")

def main():
    # Create fonts directory if it doesn't exist
    fonts_dir = Path("assets/fonts")
    fonts_dir.mkdir(parents=True, exist_ok=True)
    
    # Font URLs
    fonts = {
        "Poppins-Regular.ttf": "https://github.com/google/fonts/raw/main/ofl/poppins/Poppins-Regular.ttf",
        "Poppins-Medium.ttf": "https://github.com/google/fonts/raw/main/ofl/poppins/Poppins-Medium.ttf",
        "Poppins-SemiBold.ttf": "https://github.com/google/fonts/raw/main/ofl/poppins/Poppins-SemiBold.ttf",
        "Poppins-Bold.ttf": "https://github.com/google/fonts/raw/main/ofl/poppins/Poppins-Bold.ttf",
    }
    
    for font_name, url in fonts.items():
        destination = fonts_dir / font_name
        try:
            download_file(url, str(destination))
        except Exception as e:
            print(f"Error downloading {font_name}: {e}")

if __name__ == "__main__":
    main()
