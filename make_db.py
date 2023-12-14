import glob
import os
import json
import re
import sqlite3

empty_count = 0


class Poem:
    __slots__ = ('id', 'title', 'author', 'text')

    def __init__(self, id, title, author, text):
        self.id = id
        self.title = title
        self.author = author

        #text = re.sub(r'(？|！)(?!\n|$)', r'\1\n', text)
        #text = re.sub(r'^YY', '', text, flags=re.M)
        assert 'YY' not in text, '出现YY字符'

        self.text = text

    def get_tuple(self):
        return (self.id,
                self.title.encode('utf_16_le'),
                self.author.encode('utf_16_le'),
                self.text.encode('utf_16_le'))

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

def load_poem():
    def key(s):
        r = re.search(r'\.(\d+)\.', s)
        r = r.group(1)
        return int(r)

    l = glob.glob('poet.song.*.json')
    l.sort(key=key)

    lst = []
    id = 1
    for fn in l:
        print('正在加载文件', fn)

        with open(fn, encoding='utf-8') as f:
            obj = json.load(f)

        for d in obj:
            title = d['title']
            author = d['author']

            paras = d['paragraphs']
            text = process_paragraphs(paras)
            text = findbrace(id, text)

            if not text:
                global empty_count
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
    sql = ('CREATE TABLE Tpoem('
           'id INTEGER PRIMARY KEY,'
           'title BLOB,'
           'author BLOB,'
           'content BLOB);')
    db.execute(sql)

    return db


def save_close_db(lst, db):
    sql = 'INSERT INTO Tpoem VALUES(?,?,?,?);'
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
    # 删已有
    try:
        os.remove(db_name)
    except Exception as e:
        print(e)

    # 诗
    lst = load_poem()

    # 建数据库
    db = create_db(db_name)
    # 写数据库
    save_close_db(lst, db)

    print('无内容的记录%d条' % empty_count)

main()
