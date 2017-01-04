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
    creds = get_creds()
    halo_session = cloudpassage.HaloSession(creds["halo_key"],
                                            creds["halo_secret"])
    servers = cloudpassage.Server(halo_session)
    return servers.list_all()


@app.task
def group_report(target):
    halo = apputils.Halo()
    returnhalo.generate_group_report(target)


@app.task
def list_all_groups():
    creds = get_creds()
    halo_session = cloudpassage.HaloSession(creds["halo_key"],
                                            creds["halo_secret"])
    servers = cloudpassage.ServerGroup(halo_session)
    return servers.list_all()
