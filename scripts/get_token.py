import sys, json;

data = json.load(sys.stdin)

with open(data['input_file'], 'r') as f:
    for line in f.readlines():
        if '--token ' not in line:
           continue

        s = line.split(' ')
        tidx = s.index('--token')
        print(json.dumps({'token': s[tidx+1]}))
        break