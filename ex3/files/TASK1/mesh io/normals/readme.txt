How to get normals for the bunny mesh:

    [V,F,~,~,~] = readOFF( 'bun.off' );
    N = per_vertex_normals(V,F);
	
Afterwards, use V,F and N normally.
