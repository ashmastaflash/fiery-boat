from celery import Celery
import cloudpassage


app = Celery(backend='redis://redis')


@app.task
def add(x, y):
    return x + y


@app.task
def mul(x, y):
    return x * y


@app.task
def xsum(numbers):
    return sum(numbers)


@app.task
def list_all_servers(halo_key, halo_secret):
    halo_session = cloudpassage.HaloSession(halo_key, halo_secret)
    servers = cloudpassage.Server(halo_session)
    return servers.list_all()
