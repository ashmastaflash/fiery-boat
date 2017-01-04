import apputils
from celery import Celery

app = Celery(backend='redis://redis')


@app.task
def server_report(target):
    """Accepts a hostname or server_id"""
    halo = apputils.Halo()
    return halo.generate_server_report(target)


@app.task
def list_all_servers():
    halo = apputils.Halo()
    return halo.list_all_servers()


@app.task
def group_report(target):
    halo = apputils.Halo()
    returnhalo.generate_group_report(target)


@app.task
def list_all_groups():
    halo = apputils.Halo()
    return halo.list_all_groups()
