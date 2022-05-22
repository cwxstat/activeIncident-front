
```bash
db.events.aggregate([
    {$match: {"incidents.municipality": {$eq:"CHELTENHAM"}}}, // <-- match only the document which have a matching element
    {$project: {
	incidents: {$filter: {
            input: "$incidents",
            as: "incidents",
            cond: {$eq: ["$$incidents.municipality", "CHELTENHAM"]} //<-- filter sub-array based on condition
        }}
    }}
]);

```