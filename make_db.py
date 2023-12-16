import glob
import os
import json
import re
import sqlite3
from zhconv import convert

empty_count = 0


class Poem:
    __slots__ = ('id', 'title', 'author', 'text','love')

    def __init__(self, id, title, author, text):
        self.id = id
        self.title = title
        self.author = author
        self.love = 0

        #text = re.sub(r'(？|！)(?!\n|$)', r'\1\n', text)
        #text = re.sub(r'^YY', '', text, flags=re.M)
        assert 'YY' not in text, '出现YY字符'

        self.text = text

    def get_tuple(self):
        return (self.id,
                convert(self.title,'zh-cn'),
                convert(self.author,'zh-cn'),
                convert(self.text,'zh-cn'),
                self.love)

    def __str__(self):
        return 'ID:%d\n标题：%s\n作者：%s\n内容：\n%s\n' % \
                (self.id, self.title, self.author, self.text)


def process_paragraphs(paragraphs):
    for i in range(0, len(paragraphs)):
        # 去掉 -2222-
        m = re.search(r'-\d+-?', paragraphs[i])
        if m:
            p = re.sub(r'-\d+-?', r'', paragraphs[i])
            paragraphs[i] = p

        # 只含。的行
        if paragraphs[i] == '。':
            paragraphs[i] = ''

    return '\n'.join(p for p in paragraphs if p != '')

def findbrace(id, s):
    return re.sub(r'\n([）」』〗])', r'\1', s)

def load_poem(type):
    global empty_count
    def key(s):
        print(s)
        r = re.search(r'\.(\d+)\.', s)
        r = r.group(1)
        return int(r)
    if type =="Spoem":
        l = glob.glob('ci.song.*.json')
        l.sort(key=key)
    elif type=='Tpoem':
        l = glob.glob('poet.tang.*.json')
        l.sort(key=key)
    elif type=="song":
        l=['shijing.json']
    lst = []
    id = 1
    for fn in l:
        print('正在加载文件', fn)

        with open(fn, encoding='utf-8') as f:
            obj = json.load(f)

        for d in obj:
            try:
                if type =="song":
                        title = d['title']
                        author = d['chapter']+"·"+d['section']
                        paras = d['content']
                elif type=='Spoem':
                    title = d['rhythmic']
                    author = d['author']
                    paras = d['paragraphs']
                elif type=="Tpoem":
                    title = d['title']
                    author = d['author']
                    paras = d['paragraphs']
                text = process_paragraphs(paras)
                text = findbrace(id, text)
            except:
                empty_count += 1
                continue

            if not text:
                empty_count += 1

            p = Poem(id, title, author, text)

            # m = re.search(r'[^\u0000-\uffff]', str(p))
            # if m:
                # raise Exception('出现non-BMP字符！')

            lst.append(p)
            id += 1

    print('载入%d条记录' % len(lst))
    return lst


def create_db(db_name):
    db = sqlite3.connect(db_name, isolation_level=None)

    # 建表
    create_t_sql = ('CREATE TABLE IF NOT EXISTS Tpoem('
           'id INTEGER PRIMARY KEY,'
           'title TEXT,'
           'author TEXT,'
           'content TEXT,'
           'love INTEGER);')
    create_s_sql = ('CREATE TABLE IF NOT EXISTS  Spoem('
           'id INTEGER PRIMARY KEY,'
           'title BLOB,'
           'author BLOB,'
           'content BLOB,'
           'love INTEGER);')
    create_song_sql = ('CREATE TABLE IF NOT EXISTS song('
           'id INTEGER PRIMARY KEY,'
           'title TEXT,'
           'author TEXT,'
           'content TEXT,'
           'love  INTEGER);')
    db.execute(create_t_sql)
    db.execute(create_s_sql)
    db.execute(create_song_sql)

    return db


def save_close_db(db, lst, mtype):
    sql = 'INSERT INTO {0} VALUES(?,?,?,?,?);'.format(mtype)
    db.execute('BEGIN')
    for p in lst:
        db.execute(sql, p.get_tuple())
    db.commit()

    # 关闭数据库
    db.execute('VACUUM')
    db.close()


def main():
    #json data:https://github.com/chinese-poetry/chinese-poetry
    db_name = 'shi.db'
    # # 删已有
    # try:
    #     os.remove(db_name)
    # except Exception as e:
    #     print(e)
    # 建数据库
    db = create_db(db_name)

    # 诗
    mtype='Tpoem'
    # mtype='Spoem'
    # mtype='song'
    lst = load_poem(mtype)
    # 写数据库
    save_close_db(db,lst,mtype)

    print('无内容的记录%d条' % empty_count)

main()
