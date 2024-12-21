import urllib.request
import os

FONTS = {
    'Lato': [
        ('Regular', 'https://fonts.gstatic.com/s/lato/v24/S6uyw4BMUTPHjx4wXg.ttf'),
        ('Bold', 'https://fonts.gstatic.com/s/lato/v24/S6u9w4BMUTPHh6UVSwiPHA.ttf'),
    ],
    'PlayfairDisplay': [
        ('Regular', 'https://fonts.gstatic.com/s/playfairdisplay/v37/nuFvD-vYSZviVYUb_rj3ij__anPXJzDwcbmjWBN2PKdFvXDXbtY.ttf'),
        ('Bold', 'https://fonts.gstatic.com/s/playfairdisplay/v37/nuFvD-vYSZviVYUb_rj3ij__anPXJzDwcbmjWBN2PKeiu7Y.ttf'),
    ]
}

fonts_dir = 'assets/fonts'
if not os.path.exists(fonts_dir):
    os.makedirs(fonts_dir)

for family, variants in FONTS.items():
    for variant, url in variants:
        filename = f'{family}-{variant}.ttf'
        filepath = os.path.join(fonts_dir, filename)
        print(f'Downloading {filename}...')
        urllib.request.urlretrieve(url, filepath)
        print(f'Downloaded {filename}')
