'''
Pool query from Blockchain.
'''

import datetime as dt
import requests
import pandas as pd
import pprint as pp


# should added date check for update.

def query_pool(days, timespan_unit):
    '''
    A simple miner pool data query from Blockchain API.

    Inputs:
        days: (range)
        timespan_unit: could be minutes, hours, days, weeks

    Output: (csv)
    '''
    pool_dict = {}
    sorter = []
    for i in days:
        timespan = str(i) + timespan_unit
        date = (dt.date.today() - dt.timedelta(days= i - 1)).strftime("%m/%d/%Y")
        if date not in pool_dict:
            pool_dict[date] = ""
            sorter.append(date)
        url = "https://api.blockchain.info/pools?timespan=" + timespan
        r = requests.get(url)
        pool_dict[date] = r.json()

    df = pd.DataFrame(pool_dict, dtype='int64')
    df = df[sorter]

    for i in days:
        try:
            df[df.columns[-i]] = df[df.columns[-i]] - df[df.columns[- (i + 1)]]
        except IndexError:
            break

    df = df.fillna(0)
    for col in df.columns:
        df[col] = df[col].astype('int')

    tdt = (dt.date.today() - dt.timedelta(days= i - 1)).strftime("%Y%m%d")
    fn = tdt + "_miner_pool_last10days.csv"
    df.T.to_csv(fn)


def main():
    LIMIT = range(1,11) # Blockchain.info allows 10-day traceback
    UNIT = "days"
    query_pool(LIMIT, UNIT)


if __name__ == '__main__':
    main()
