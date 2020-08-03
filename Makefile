all:
	cp subtemplate-src/admin-aadNestedTemplate.md admin/aadNestedTemplate.md
	cp subtemplate-src/cluster-aadNestedTemplate.md cluster/aadNestedTemplate.md
	cp subtemplate-src/dynamic-cluster-aadNestedTemplate.md dynamic-cluster/aadNestedTemplate.md
	cp subtemplate-src/dbTemplate.md admin
	cp subtemplate-src/dbTemplate.md cluster
	cp subtemplate-src/dbTemplate.md dynamic-cluster
	cp subtemplate-src/appGatewayNestedTemplate.md cluster
	cp subtemplate-src/cluster-deletenode.md cluster/deletenode.md
	cp subtemplate-src/dynamic-cluster-deletenode.md dynamic-cluster/deletenode.md
	cp subtemplate-src/cluster-addnode.md cluster/addnode.md
	cp subtemplate-src/dynamic-cluster-addnode.md dynamic-cluster/addnode.md

