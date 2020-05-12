# Matlab script for sneeze particles
## Usage:   q = read_balance_diam(pathname, fignum);
## Example: q = read_balance_diam('./data/', 0);
## Input arguments:
### *pathname*: path to data of the form fbalance?????.3D
### *fignum*: figure index where pdf for each particle force will be displayed. Set to zero to prevent plotting.

## Output arguments:
### nt = number of time frames
### np = number of particles
### ndim = 4 (1=x, 2=y, 3=z, 4=magnitude)

### *q*: Matlab struct with:

1. q.t[nt]            : Time
2. q.xp[np,nt,ndim]   : position
3. q.up[np,nt,ndim+2] : velocity
4. q.ap[np,nt,ndim]   : acceleration
5. q.dp[np,nt,ndim]   : drag
6. q.wp[np,nt]        : weight
7. q.tp[np,nt,ndim]   : thermophoresis
8. q.lp[np,nt,ndim]   : lift
9. q.bp[np,nt,ndim]   : brownian
10. q.sp[np,nt]       : diameter
11. q.np[np,nt]       : normalized diameter

# Comments:
If used under Windows, reading part must be modified.
