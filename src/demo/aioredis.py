import asyncio
import aioredis

redis = aioredis.from_url("redis://localhost")


async def main():
    await redis.set("aiofoo", "bar")
    r = await redis.get("aiofoo")
    print(r)


if __name__ == "__main__":
    asyncio.run(main())
