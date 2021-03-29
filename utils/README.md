# Utilities
- `parse_env.py`

  Parses and dumps `.env` file content to be feed to `etcdctl`.

  To directly feed this script results to `etcdctl`, run:

  ```bash
  # using http://192.168.0.68:2379 as etcd endpoint and /com/qeon/www/envs as etcd key prefix:

  export ETCDCTL_API=3

  python3 parse_env.py /path/to/.env | while read -r KEY; do read -r VALUE; etcdctl --endpoints http://192.168.0.68:2379 put /com/qeon/www/envs/$KEY "$VALUE"; done
  ```