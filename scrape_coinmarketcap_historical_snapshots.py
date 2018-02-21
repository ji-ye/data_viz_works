'''
Scrape Historical crpytocurrency data from coinmarketcap.com and clean it for D3.
'''

from datetime import datetime
import bs4
import requests
import pandas as pd


main_url = "https://coinmarketcap.com/historical/"
resp = requests.get(main_url)
html = resp.content
soup = bs4.BeautifulSoup(html, 'html.parser')


def is_number(s):
    '''
    Checking if a Python String is a Number.
    http://www.pythoncentral.io/how-to-check-if-a-string-is-a-number-in-python-including-unicode/
    '''
    try:
        float(s)
        return True
    except ValueError:
        pass

    try:
        import unicodedata
        unicodedata.numeric(s)
        return True
    except (TypeError, ValueError):
        pass

    return False


# Find all snapshot url.
lst_url = []
for item in soup.find_all('a', href=True, text=True):
    txt = item.get_text()
    if is_number(txt):
        lst_url.append(item.get("href"))

# Scrape all snapshot url.
d2 = {}
url_home = "https://coinmarketcap.com"

for url in lst_url:
    date = url[-9:-1]
    if str(date) not in d2:
        d2[str(date)] = []

    date_url = url_home + url
#     print(date)
# print(d2.keys())

    resp=requests.get(date_url)
    html=resp.content
    soup=bs4.BeautifulSoup(html, 'html.parser')

    name = [item.get_text() for item in soup.find_all("a", "currency-name-container")]
    d2[str(date)].append(name)

    symbol = [item.get_text() for item in soup.find_all("td", "col-symbol")]
    d2[str(date)].append(symbol)

    market_cap = [item['data-usd'] for item in soup.find_all('td',  attrs={"class": "market-cap", 'data-usd' : True})]
    d2[str(date)].append(market_cap)

    price = [item['data-usd'] for item in soup.find_all('a',  attrs={"class": "price", 'data-usd' : True})]
    d2[str(date)].append(price)


lst_formatted = []
for k in d2.keys():
    for i in range(len(d2[k][0])):
        row = [d2[k][0][i], d2[k][1][i], d2[k][2][i], d2[k][3][i], k]
        lst_formatted.append(row)


df = pd.DataFrame.from_dict(lst_formatted)
# df.dtypes
df.columns = ["name", "symbol", "market_cap", "price", "date"]

# clean out rows without market cap
df = df[df.market_cap != "?"]

# change data types
df.market_cap = pd.to_numeric(df.market_cap)
df.price = pd.to_numeric(df.price)
df['date'] = pd.to_datetime(df['date'], format='%Y%m%d')



df = df.sort_values(["date", 'market_cap'], ascending=[True, False])
# Save raw data
df.to_csv("market_cap_weekly.csv", index=False)

'''
A glimpse

df.market_cap.groupby(df.date).sum().plot()
df[df.name=="Bitcoin"].market_cap.groupby(df.date).sum().plot()
df[df.symbol=="ETC"].market_cap.groupby(df.date).sum().plot()
df[df.name == "Ethercoin"].market_cap.groupby(df.date).sum().plot()
df[df.name == "Ethereum"].market_cap.groupby(df.date).sum().plot()
df[df.name == "Ethereum Classic"].market_cap.groupby(df.date).sum().plot()
df[df.symbol == 'BCH'].market_cap.groupby(df.date).sum().plot()
df[df.symbol=="ETH"].market_cap.groupby(df.date).sum().plot()
df[df.symbol=="LTC"].market_cap.groupby(df.date).sum().plot()
'''
# Consolidated data by keeping the name of top 5 coins, and combine the rest.

# Find coins with highest total historic market cap.
# It is Bitcoin, Ethereum, Ripple, Bitcoin Cash, Litecoin
# They are also the top five coins on the same order of magnitude (e+11)
grouped = df.market_cap.groupby([df.name, df.symbol]).sum().reset_index()
grouped.sort_values('market_cap', ascending=False)

df_copy = df
# df = df_copy

df_top = df[df.name.isin(["Bitcoin", "Ethereum", "Ripple", "Bitcoin Cash", "Litecoin"])]
df_other = df[~df.name.isin(["Bitcoin", "Ethereum", "Ripple", "Bitcoin Cash", "Litecoin"])]

grouped_other = df_other.groupby("date").sum().reset_index()
grouped_other["name"] = "Other Altcoins"
grouped_other["symbol"] = "etc."

df_agg = pd.concat([df_top, grouped_other])

df_agg = df_agg[['name', 'symbol', 'market_cap', 'price',  'date']]

df_agg = df_agg.sort_values(["date", 'market_cap'], ascending=[True, False])

df_agg.to_csv('market_capp_agg_weekly.csv', index=False)
