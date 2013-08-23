import numpy as np
from scipy.integrate import ode

def fex(t, y):
    ydot = np.zeros(3)
    ydot[0] = -0.04 * y[0] + 1.0e4 * y[1] * y[2]
    ydot[2] = 3.0e7 * y[1] * y[1]
    ydot[1] = -ydot[0] - ydot[2]
    return ydot

rtol = 1.0e-4
atol = np.array([1.0e-6, 1.0e-10, 1.0e-6])

r = ode(fex).set_integrator('lsoda', rtol=rtol, atol=atol)
t0 = 0.0
y0 = [1.0, 0.0, 0.0]
r.set_initial_value(y0, t0)
t2 = 0.4

while r.successful() and r.t < 4e10:
    r.integrate(t2)
    print("At t = {:.4e}   y = {}".format(r.t, r.y))
    t2 = t2 * 10

print("No. steps = {}, no. f-s = {}, no. j-s = {}".format(r._integrator.iwork[10], r._integrator.iwork[11], r._integrator.iwork[12]))
print("method last used = {}, last switch at t = {:.4e}".format(r._integrator.iwork[18], r._integrator.rwork[14]))
