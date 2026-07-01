 kubectl patch externalsecret redis-auth   -n redis   --type=merge   -p '{"metadata":{"finalizers":[]}}'
