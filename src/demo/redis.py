import redis

while True:
    r = redis.Redis(host="localhost", port=6379)
    r.set("foo", "bar")
    print(r.get("foo"))
