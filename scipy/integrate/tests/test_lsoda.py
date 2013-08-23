import numpy as np
import scipy.integrate.lsoda as _lsoda

def fex(t, y):
    ydot = np.zeros(3)
    ydot[0] = -0.04 * y[0] + 1.0e4 * y[1] * y[2]
    ydot[2] = 3.0e7 * y[1] * y[1]
    ydot[1] = -ydot[0] - ydot[2]
    return ydot

def jac(t, y):
    return np.zeros((3, 3))

rwork = np.zeros(70)

iwork = np.zeros(23)

y = np.array([1.0, 0.0, 0.0])
t = 0.0
tout = 0.4

rtol = 1.0e-4
atol = np.array([1.0e-6, 1.0e-10, 1.0e-6])

itask = 1
istate = 1
iopt = 0
jt = 2

for ii in range(12):
    y, t, istate = _lsoda.lsoda(fex, y, t, tout, rtol, atol, itask, istate,
                                rwork, iwork, jac, jt)
    print("At t = {:.4e}   y = {}".format(t, y))
    if istate < 0:
        print("Error, istate = {}".format(istate))
        break

    tout = tout * 10.0

print("No. steps = {}, no. f-s = {}, no. j-s = {}".format(iwork[10], iwork[11], iwork[12]))
print("method last used = {}, last switch at t = {:.4e}".format(iwork[18], rwork[14]))
