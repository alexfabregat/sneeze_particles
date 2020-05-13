# Matlab script for sneeze particles
## Usage:   q = read_balance_diam(pathname, fignum);
## Example: `q = read_balance_diam('./data/', 0);`
## Input arguments:
### *pathname*: path to data of the form fbalance?????.3D
### *fignum*: figure index where pdf for each particle force will be displayed. Set to zero to prevent plotting.

## Output arguments:
### nt = number of time frames
### np = number of particles
### ndim = 4 (1=x, 2=y, 3=z, 4=magnitude)

### *q*: Matlab struct with:

Struct element | Size | Meaning 
---|---|---
q.t |(nt)|           Time
q.xp|(np,nt,ndim)|   Position
q.up|(np,nt,ndim+2)| Velocity
q.ap|(np,nt,ndim)|   Acceleration
q.dp|(np,nt,ndim)|   Drag
q.wp|(np,nt)|        Weight
q.tp|(np,nt,ndim)|   Thermophoresis
q.lp|(np,nt,ndim)|   Lift
q.bp|(np,nt,ndim)|   Brownian
q.sp|(np,nt)|        Diameter
q.np|(np,nt)|        Normalized diameter

# Comments:
Note that a Windows version of the code is available.
