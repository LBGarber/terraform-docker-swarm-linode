import sys, json, subprocess

data = json.load(sys.stdin)

run_output = subprocess.check_output(['scp', '-i', data['ssh_private_key'], 'root@{0}:/root/swarmoutput.txt'.format(data['ip_address']), '/dev/stdout'])

for line in str(run_output).split('\n'):
    if '--token ' not in line:
       continue

    s = line.split(' ')
    tidx = s.index('--token')
    print(json.dumps({'token': s[tidx+1]}))
    break