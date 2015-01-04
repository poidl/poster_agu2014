function s=stabilize(s,ct,p)

tis=gsw_t_from_CT(s,ct,p);
s=gsw_stabilise_t_neutral(s,tis,p);