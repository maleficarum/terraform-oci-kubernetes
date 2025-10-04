# Listing available images

To set the proper image OCID, you can query the available images from your tenant based on your root compartment OCID : 

```bash
oci ce node-pool-options get --node-pool-option-id all
```

# FSDR Policies

    At level landing-zone where compartment tree is like : 

    landing-zone:
        - production_ash
        - production_phx

```bash
Allow dynamic-group id ocid1.dynamicgroup.oc1..aaaaaaaa4gdfjghoopjmdhvovba6lkqeysowuc22cnbydrxsqb5a7vsdfm7q to manage cluster-family in compartment id ocid1.compartment.oc1..aaaaaaaap2og6mlovycnaqjoqardqfkhnvg4mxcvs4t6r2z5fcswkwyywdiq # OKE CLUSTER compartment ID ASH
Allow dynamic-group id ocid1.dynamicgroup.oc1..aaaaaaaa4gdfjghoopjmdhvovba6lkqeysowuc22cnbydrxsqb5a7vsdfm7q to manage object-family in compartment id ocid1.compartment.oc1..aaaaaaaak435fgwkrzkgbkbvwio5s4ataqr3fbk4rgvjlkwa73ynaxqbbjnq # PRODUCTION ASH COMPARTMENT ID DONDE ESTA EL OBJECT STORATE
Allow dynamic-group id ocid1.dynamicgroup.oc1..aaaaaaaa4gdfjghoopjmdhvovba6lkqeysowuc22cnbydrxsqb5a7vsdfm7q to manage cluster-family in compartment id ocid1.compartment.oc1..aaaaaaaajrkqwshxcevho5nu3nqrummxe5yehyirf4klkyl76vep5qdrivgq # OKE CLUSTER ID PHX
Allow dynamic-group id ocid1.dynamicgroup.oc1..aaaaaaaa4gdfjghoopjmdhvovba6lkqeysowuc22cnbydrxsqb5a7vsdfm7q to manage object-family in compartment id ocid1.compartment.oc1..aaaaaaaakwctabxhgw5adjpyjsce6yxbrhxyhvyl4hnhkryf2ervqad7dvaa # PRODUCTION PHX COMPARTMENT ID DONDE ESTA EL OBJECT STORAGE
```

Dynamic group

```bash
All {instance.compartment.id = 'ocid1.compartment.oc1..aaaaaaaap2og6mlovycnaqjoqardqfkhnvg4mxcvs4t6r2z5fcswkwyywdiq'} # OKE Cluster compartment id ASH
All {instance.compartment.id = 'ocid1.compartment.oc1..aaaaaaaajrkqwshxcevho5nu3nqrummxe5yehyirf4klkyl76vep5qdrivgq'} # OKE Clsuter compartment id PHX
All {resource.type='computecontainerinstance'}
```



```bash
Allow dynamic-group id ocid1.dynamicgroup.oc1..aaaaaaaaixhdaa4fc4ooqwnpn2vsfizd7oxxwge6physwnew4qdvazwukubq to manage cluster-family in compartment id ocid1.compartment.oc1..aaaaaaaakryzwvqs7mp54k3k6czozie57mcvkawaplhov5p5xpvljtzkyxeq # OKE CLUSTER COMPARTMENT OCID IN QRO
Allow dynamic-group id ocid1.dynamicgroup.oc1..aaaaaaaaixhdaa4fc4ooqwnpn2vsfizd7oxxwge6physwnew4qdvazwukubq to manage object-family in compartment id ocid1.compartment.oc1..aaaaaaaahbjfki2rgbbd54nc5i6f3icb3gwqds3j6bv2hxaka6gdgkyfd4tq 
# PRODUCTION QRO COMPARTMENT OCID (WHERE BUCKET IS)
Allow dynamic-group id ocid1.dynamicgroup.oc1..aaaaaaaaixhdaa4fc4ooqwnpn2vsfizd7oxxwge6physwnew4qdvazwukubq to manage cluster-family in compartment id ocid1.compartment.oc1..aaaaaaaabg35uqekdyl2br5zebsryhrcmngcmifbqgx2trn5ibzz5kcbvu7a # OKE CLUSTER COMPARTMENT OCID IN MTY
Allow dynamic-group id ocid1.dynamicgroup.oc1..aaaaaaaaixhdaa4fc4ooqwnpn2vsfizd7oxxwge6physwnew4qdvazwukubq to manage object-family in compartment id ocid1.compartment.oc1..aaaaaaaaf7gtlnakoxfb6fh6czj2hzf5a3wuda5absxkltomaognbwnqg3ea 
# PRODUCTION MTY COMPARTMENT OCID (WHERE BUCKET IS)