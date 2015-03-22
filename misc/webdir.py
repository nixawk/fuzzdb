import os
path = '/home/user/someone/wordpress'
for root,visited,names in os.walk(path):
    root = root.rstrip('/').__add__('/')
    for file_ in names:
        file_p = root.__add__(file_)
        file_p = file_p.replace('\\','/')
        file_p = file_p.replace(path,'/')
        print file_p
