// ============================================================
// EXPERIMENT NO. 8
// Aim: Case Study – Social Media Data Processing using NoSQL
// Run these commands in MongoDB Shell (mongosh) or Compass
// ============================================================


// ============================================================
// STEP 1: SELECT / CREATE DATABASE
// ============================================================

use social_media_db


// ============================================================
// STEP 2: INSERT SAMPLE DATASET (social media posts)
// ============================================================

db.posts.insertMany([
    {
        post_id: 1,
        user: "Rahul",
        content: "Learning AI is fun!",
        hashtags: ["AI", "MachineLearning"],
        likes: 120,
        comments: 15,
        timestamp: "2024-03-01"
    },
    {
        post_id: 2,
        user: "Sneha",
        content: "Big data is the future",
        hashtags: ["BigData", "DataScience"],
        likes: 95,
        comments: 10,
        timestamp: "2024-03-02"
    },
    {
        post_id: 3,
        user: "Amit",
        content: "Python for data science is awesome",
        hashtags: ["Python", "DataScience", "AI"],
        likes: 200,
        comments: 30,
        timestamp: "2024-03-03"
    },
    {
        post_id: 4,
        user: "Priya",
        content: "Deep learning applications in healthcare",
        hashtags: ["AI", "DeepLearning", "Healthcare"],
        likes: 80,
        comments: 8,
        timestamp: "2024-03-04"
    },
    {
        post_id: 5,
        user: "Rahul",
        content: "MongoDB is great for NoSQL!",
        hashtags: ["MongoDB", "NoSQL", "BigData"],
        likes: 150,
        comments: 20,
        timestamp: "2024-03-05"
    },
    {
        post_id: 6,
        user: "Ravi",
        content: "Machine learning trends 2024",
        hashtags: ["MachineLearning", "AI", "Python"],
        likes: 175,
        comments: 25,
        timestamp: "2024-03-06"
    },
    {
        post_id: 7,
        user: "Meena",
        content: "DataScience career guide",
        hashtags: ["DataScience", "Career"],
        likes: 60,
        comments: 5,
        timestamp: "2024-03-07"
    },
    {
        post_id: 8,
        user: "Sneha",
        content: "Natural Language Processing overview",
        hashtags: ["NLP", "AI", "MachineLearning"],
        likes: 110,
        comments: 18,
        timestamp: "2024-03-08"
    }
])


// ============================================================
// STEP 3: VIEW ALL DATA
// ============================================================

db.posts.find().pretty()


// ============================================================
// STEP 4: FILTER DATA QUERIES
// ============================================================

// i. Find posts with more than 100 likes
db.posts.find({ likes: { $gt: 100 } })

// ii. Find posts by specific user
db.posts.find({ user: "Rahul" })

// iii. Find posts containing specific hashtag
db.posts.find({ hashtags: "AI" })

// iv. Sort posts by likes (descending)
db.posts.find().sort({ likes: -1 })

// v. Limit results to top 5 posts by likes
db.posts.find().sort({ likes: -1 }).limit(5)

// vi. Find posts with more than 100 likes AND by Rahul
db.posts.find({
    $and: [
        { likes: { $gt: 100 } },
        { user: "Rahul" }
    ]
})

// vii. Find posts by multiple users (IN operator)
db.posts.find({ user: { $in: ["Rahul", "Sneha"] } })

// viii. Find posts with comments between 10 and 25
db.posts.find({ comments: { $gte: 10, $lte: 25 } })

// ix. Posts that contain both "AI" and "Python" hashtags
db.posts.find({ hashtags: { $all: ["AI", "Python"] } })


// ============================================================
// STEP 5: DATA ANALYSIS USING AGGREGATION FRAMEWORK
// ============================================================

// --- Find Top Trending Hashtags ---
db.posts.aggregate([
    { $unwind: "$hashtags" },            // Split hashtag array into individual entries
    {
        $group: {
            _id: "$hashtags",             // Group by each hashtag
            count: { $sum: 1 }            // Count occurrences
        }
    },
    { $sort: { count: -1 } },            // Sort by frequency (descending)
    { $limit: 5 }                         // Show top 5 only
])

// --- Total Likes per User ---
db.posts.aggregate([
    {
        $group: {
            _id: "$user",
            totalLikes: { $sum: "$likes" },
            totalPosts: { $sum: 1 }
        }
    },
    { $sort: { totalLikes: -1 } }
])

// --- Average Likes per Post ---
db.posts.aggregate([
    {
        $group: {
            _id: null,
            averageLikes: { $avg: "$likes" },
            totalPosts: { $sum: 1 }
        }
    }
])

// --- Most Active Users (most posts) ---
db.posts.aggregate([
    {
        $group: {
            _id: "$user",
            postCount: { $sum: 1 }
        }
    },
    { $sort: { postCount: -1 } }
])

// --- Posts per Day (group by timestamp) ---
db.posts.aggregate([
    {
        $group: {
            _id: "$timestamp",
            postCount: { $sum: 1 },
            totalLikes: { $sum: "$likes" }
        }
    },
    { $sort: { _id: 1 } }
])


// ============================================================
// STEP 6: INDEXING FOR PERFORMANCE
// ============================================================

// Create index on user field
db.posts.createIndex({ user: 1 })

// Create index on likes (descending) for fast top-posts queries
db.posts.createIndex({ likes: -1 })

// Create index on hashtags array
db.posts.createIndex({ hashtags: 1 })

// Create compound index on user + timestamp
db.posts.createIndex({ user: 1, timestamp: 1 })

// View all indexes
db.posts.getIndexes()

// Explain query to verify index usage
db.posts.find({ user: "Rahul" }).explain("executionStats")


// ============================================================
// CRUD: UPDATE and DELETE
// ============================================================

// Update likes for a specific post
db.posts.updateOne(
    { post_id: 1 },
    { $set: { likes: 135 } }
)

// Add a new hashtag to an existing post
db.posts.updateOne(
    { post_id: 2 },
    { $push: { hashtags: "Technology" } }
)

// Delete a specific post
db.posts.deleteOne({ post_id: 8 })

// Delete all posts by a user
// db.posts.deleteMany({ user: "Meena" })   // Uncomment to test

// ============================================================
// UTILITY
// ============================================================

// Count total posts
db.posts.countDocuments()

// Count posts with more than 100 likes
db.posts.countDocuments({ likes: { $gt: 100 } })

// View collection stats
db.posts.stats()
