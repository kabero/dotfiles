import sys
from bs4 import BeautifulSoup


args = sys.argv
file_name = args[1]

with open(file_name, 'r') as f:
    bookmark_html = f.read()

soup = BeautifulSoup(bookmark_html, 'html.parser')
titles = [a_tag.get_text() for a_tag in soup.find_all('a')]
links = [url.get('href') for url in soup.find_all('a')]

if titles:
    print('Others:')
    for title, link in zip(titles, links):
        print(f'    - {title} # {link}')
