# Forum Export Archive

**Export Date:** 2025-12-21 02:21:10 UTC
**Source Database:** the-flying-dutchmen (local development)
**Export Version:** 1.0

## Contents

- **4 users** (3 with avatars)
- **7 forum categories**
- **23 forum threads**
- **366 forum posts** (with embedded images)
- **Total Images Downloaded:** 3
- **Failed Downloads:** 0

## Directory Structure

```
export/
├── README.md                    # This file
├── csv/
│   ├── users.csv               # User accounts
│   ├── forum_categories.csv    # Forum categories
│   ├── forum_threads.csv       # Discussion threads
│   └── forum_posts.csv         # Individual posts with HTML content
├── images/
│   ├── users/{user_id}/avatar.{ext}
│   └── posts/{post_id}/image_{n}.{ext}
└── metadata/
    ├── export_log.txt          # Detailed export log
    ├── attachment_mapping.json # SGID to file path mapping
    └── statistics.json         # Export statistics
```

## CSV Files

### users.csv
Fields: id, email, username, moderator, settings_json, avatar_path, created_at, updated_at

- `avatar_path`: Relative path to user's avatar image (if they have one)
- `settings_json`: User settings as JSON string

### forum_categories.csv
Fields: id, name, slug, color, created_at, updated_at

- `color`: Hex color code for category display

### forum_threads.csv
Fields: id, forum_category_id, user_id, title, slug, forum_posts_count, pinned, solved, created_at, updated_at

- `forum_category_id`: Foreign key to forum_categories.csv
- `user_id`: Foreign key to users.csv (thread author)
- `pinned`: Boolean indicating if thread is pinned to top
- `solved`: Boolean indicating if thread is marked as solved

### forum_posts.csv
Fields: id, forum_thread_id, user_id, text_html, solved, created_at, updated_at

- `forum_thread_id`: Foreign key to forum_threads.csv
- `user_id`: Foreign key to users.csv (post author)
- `text_html`: Rich text content as HTML with local image paths
- `solved`: Boolean indicating if this post solved the thread

## Images

All images have been downloaded from Google Cloud Storage and organized locally:

- **User avatars:** `images/users/{user_id}/avatar.{ext}`
- **Post images:** `images/posts/{post_id}/image_{n}.{ext}`

Image paths in `forum_posts.csv` are relative paths from the CSV directory, e.g., `../../images/posts/5/image_1.jpg`

## Notes

- All timestamps are in UTC
- Foreign key relationships are preserved via ID fields
- Rich text HTML has been processed to use local image paths instead of GCS URLs
- Missing or failed downloads are marked with `<img src="MISSING" ...>` tags
- Original ActionText blob SGIDs are mapped in `metadata/attachment_mapping.json`

## Using This Export

### Viewing Content
- CSV files can be opened in Excel, Google Sheets, or any CSV viewer
- HTML content in forum_posts.csv can be rendered in a browser
- Images can be viewed directly from the images/ folder

### Re-importing
This export format preserves all foreign key relationships and can be used to:
- Import into a new Rails application
- Migrate to a different database system
- Archive the forum content
- Analyze forum data

## Export Statistics

- Duration: 4s
- Images Downloaded: 3
- Images Failed: 0
- Total Records: 400

For detailed logs, see `metadata/export_log.txt`
