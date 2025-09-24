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

```
    Allow dynamic-group id ocid1.dynamicgroup.oc1..aaaaaaaa4gdfjghoopjmdhvovba6lkqeysowuc22cnbydrxsqb5a7vsdfm7q to manage cluster-family in compartment id ocid1.compartment.oc1..aaaaaaaap2og6mlovycnaqjoqardqfkhnvg4mxcvs4t6r2z5fcswkwyywdiq # OKE CLUSTER ID ASH
    Allow dynamic-group id ocid1.dynamicgroup.oc1..aaaaaaaa4gdfjghoopjmdhvovba6lkqeysowuc22cnbydrxsqb5a7vsdfm7q to manage object-family in compartment id ocid1.compartment.oc1..aaaaaaaak435fgwkrzkgbkbvwio5s4ataqr3fbk4rgvjlkwa73ynaxqbbjnq # PRODUCTION ASH COMPARTMENT ID
    Allow dynamic-group id ocid1.dynamicgroup.oc1..aaaaaaaa4gdfjghoopjmdhvovba6lkqeysowuc22cnbydrxsqb5a7vsdfm7q to manage cluster-family in compartment id ocid1.compartment.oc1..aaaaaaaajrkqwshxcevho5nu3nqrummxe5yehyirf4klkyl76vep5qdrivgq OKE CLUSTER ID PHX
    Allow dynamic-group id ocid1.dynamicgroup.oc1..aaaaaaaa4gdfjghoopjmdhvovba6lkqeysowuc22cnbydrxsqb5a7vsdfm7q to manage object-family in compartment id ocid1.compartment.oc1..aaaaaaaakwctabxhgw5adjpyjsce6yxbrhxyhvyl4hnhkryf2ervqad7dvaa PRODUCTION PHX COMPARTMENT ID
```

Dynamic group

```
All {instance.compartment.id = 'ocid1.compartment.oc1..aaaaaaaap2og6mlovycnaqjoqardqfkhnvg4mxcvs4t6r2z5fcswkwyywdiq'} # OKE Cluster id ASH
All {instance.compartment.id = 'ocid1.compartment.oc1..aaaaaaaajrkqwshxcevho5nu3nqrummxe5yehyirf4klkyl76vep5qdrivgq'} # OKE Clsuter id PHX
All {resource.type='computecontainerinstance'}
```