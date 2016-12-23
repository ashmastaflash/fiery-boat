from __future__ import absolute_import, unicode_literals
from .celery import app
import cloudpassage
import os


halo_key = os.getenv("HALO_API_KEY")
halo_secret = os.getenv("HALO_API_SECRET_KEY")
halo_session = cloudpassage.HaloSession(halo_key, halo_secret)


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
