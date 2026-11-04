// ============================================================
// EXPERIMENT NO. 7
// Aim: NoSQL Database – MongoDB Aggregation and Indexing
// Run these commands in MongoDB Shell (mongosh) or Compass
// ============================================================


// ============================================================
// DATABASE SETUP
// ============================================================

use student_nosql_db


// ============================================================
// CREATE COLLECTION AND INSERT DOCUMENTS
// ============================================================

// Insert a single document
db.stud.insertOne({ Name: "Jiya", age: 15, Rno: 1 })

// Insert without specifying _id (MongoDB assigns ObjectId)
db.stud.insertOne({ Name: "Reena", Rno: 15 })

// Insert with custom _id
db.stud.insertOne({ _id: 10, Name: "Reena", Rno: 15 })

// Insert single student
db.stud.insertOne({ Name: "Ankit", Rno: 1, Address: "Pune" })

// Insert multiple documents
db.stud.insertMany([
    { Name: "Ankit",  Rno: 1, Address: "Pune" },
    { Name: "Sagar",  Rno: 2 },
    { Name: "Neha",   Rno: 3 },
    { Name: "Rahul",  Rno: 4, Address: "Nashik", Age: 20 },
    { Name: "Sneha",  Rno: 5, Address: "Mumbai", Age: 22 },
    { Name: "Amit",   Rno: 6, Address: "Nagpur", Age: 21 }
])

// Insert document with multicolumn (nested) attribute
db.stud.insertOne({
    Name: "Ritu",
    Address: { City: "Pune", State: "MH" },
    Rno: 6
})

// Insert document with multivalued attribute (array)
db.stud.insertOne({
    Name: "Sneha",
    Hobbies: ["Singing", "Dancing", "Cricket"],
    Rno: 8
})

// Insert with multivalued + multicolumn attribute
db.stud.insertOne({
    Name: "Kavya",
    Awards: [
        { Award: "Dancing", Rank: "1st", Year: 2008 },
        { Award: "Drawing", Rank: "3rd", Year: 2010 },
        { Award: "Singing", Rank: "1st", Year: 2015 }
    ],
    Rno: 9
})


// ============================================================
// CRUD – READ (FIND)
// ============================================================

// Find all documents
db.stud.find()

// Find all (formatted / pretty)
db.stud.find().pretty()

// Find by exact match
db.stud.find({ Name: "Jiya" })
db.stud.find({ _id: 5 })

// Find with comparison operators
db.stud.find({ Rno: { $gt: 5 } })              // Rno > 5
db.stud.find({ Rno: { $gt: 0, $lt: 5 } })      // 0 < Rno < 5
db.stud.find({ Age: { $gte: 20 } })             // Age >= 20
db.stud.find({ Age: { $lte: 21 } })             // Age <= 21
db.stud.find({ Rno: { $ne: 3 } })               // Rno != 3

// Projection: show only specific fields
db.stud.find({ Name: "Jiya" }, { Rno: 1 })           // show Rno (and _id)
db.stud.find({ Name: "Jiya" }, { _id: 0, Rno: 1 })   // hide _id

// Sort: Ascending (1), Descending (-1)
db.stud.find().sort({ Rno: 1 })
db.stud.find().sort({ Rno: -1 })

// Count documents
db.stud.find().count()
db.stud.countDocuments()

// Limit and Skip
db.stud.find().limit(2)    // First 2 documents
db.stud.find().skip(5)     // Skip first 5 documents


// ============================================================
// CRUD – UPDATE
// ============================================================

// Replace whole document (only age field remains after update)
db.stud.update(
    { _id: 100 },
    { age: 25 }
)

// Update only one field using $set
db.stud.update(
    { Rno: 1 },
    { $set: { Age: 21 } }
)

// Update with upsert (insert if not found)
db.stud.update(
    { Rno: 99 },
    { $set: { Name: "NewStudent", Age: 18 } },
    { upsert: true }
)

// Update multiple documents
db.stud.update(
    { Address: "Pune" },
    { $set: { City: "Pune" } },
    { multi: true }
)

// Remove a field using $unset
db.stud.update(
    { Rno: 1 },
    { $unset: { Age: 1 } }
)


// ============================================================
// CRUD – DELETE (REMOVE)
// ============================================================

// Remove all documents
// db.stud.remove({})         // Uncomment to test

// Remove all documents matching condition
db.stud.remove({ Rno: 99 })

// Remove only one matching document
db.stud.remove({ Name: "Jiya" }, 1)


// ============================================================
// INDEXING
// ============================================================

// Create index on Rno (ascending)
db.stud.createIndex({ Rno: 1 })

// Create unique index on Name
db.stud.createIndex({ Name: 1 }, { unique: true })

// Create descending index
db.stud.createIndex({ Age: -1 })

// Compound index
db.stud.createIndex({ Name: 1, Rno: 1 })

// View all indexes
db.stud.getIndexes()

// Drop a specific index
db.stud.dropIndex({ Rno: 1 })


// ============================================================
// AGGREGATION
// ============================================================

// Count documents per city
db.stud.aggregate([
    { $group: { _id: "$Address", count: { $sum: 1 } } }
])

// Average age of students
db.stud.aggregate([
    { $group: { _id: null, averageAge: { $avg: "$Age" } } }
])

// Count students per city, sorted descending
db.stud.aggregate([
    { $group: { _id: "$Address", count: { $sum: 1 } } },
    { $sort: { count: -1 } }
])

// Filter then group: Only students with Age > 20, count per Address
db.stud.aggregate([
    { $match: { Age: { $gt: 20 } } },
    { $group: { _id: "$Address", count: { $sum: 1 } } }
])

// Project (reshape output)
db.stud.aggregate([
    { $project: { _id: 0, Name: 1, Rno: 1 } }
])

// ============================================================
// COLLECTION MANAGEMENT
// ============================================================

// Show all collections
show collections

// Drop the collection
// db.stud.drop()             // Uncomment to test

// Drop the database
// db.dropDatabase()          // Uncomment to test

// Show available databases
show dbs
