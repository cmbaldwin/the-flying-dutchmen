# Forum Export Archive

**Export Date:** 2025-12-22 07:25:58 UTC
**Source Database:** the-flying-dutchmen (local development)
**Export Version:** 1.0

## Contents

- **4 users** (3 with avatars)
- **7 forum categories**
- **23 forum threads**
- **366 forum posts** (with embedded images)
- **74 unassigned images** (in database but failed to download normally)
- **Total Images Downloaded:** 77
- **Failed Downloads:** 5

## Directory Structure

```
export/
├── README.md                    # This file
├── csv/
│   ├── users.csv               # User accounts
│   ├── forum_categories.csv    # Forum categories
│   ├── forum_threads.csv       # Discussion threads
│   └── forum_posts.csv         # Individual posts with HTML content
├── json/
│   ├── users.json              # User accounts (JSON format)
│   ├── forum_categories.json   # Forum categories (JSON format)
│   ├── forum_threads.json      # Discussion threads (JSON format)
│   └── forum_posts.json        # Individual posts with HTML content (JSON format)
├── images/
│   ├── users/{user_id}/avatar.{ext}
│   ├── posts/{post_id}/image_{n}.{ext}
│   └── unassigned/{key}.{ext}  # Orphaned images from GCS
└── metadata/
    ├── export_log.txt          # Detailed export log
    ├── attachment_mapping.json # SGID to file path mapping
    ├── unassigned_images.json  # Metadata for unassigned images
    └── statistics.json         # Export statistics
```

## Data Files

All data is exported in both CSV and JSON formats for maximum compatibility.

### users.csv / users.json
Fields: id, email, username, moderator, settings_json, avatar_path, created_at, updated_at

- `avatar_path`: Relative path to user's avatar image (if they have one)
- `settings_json`: User settings as JSON string

### forum_categories.csv / forum_categories.json
Fields: id, name, slug, color, created_at, updated_at

- `color`: Hex color code for category display

### forum_threads.csv / forum_threads.json
Fields: id, forum_category_id, user_id, title, slug, forum_posts_count, pinned, solved, created_at, updated_at

- `forum_category_id`: Foreign key to forum_categories
- `user_id`: Foreign key to users (thread author)
- `pinned`: Boolean indicating if thread is pinned to top
- `solved`: Boolean indicating if thread is marked as solved

### forum_posts.csv / forum_posts.json
Fields: id, forum_thread_id, user_id, text_html, solved, created_at, updated_at

- `forum_thread_id`: Foreign key to forum_threads
- `user_id`: Foreign key to users (post author)
- `text_html`: Rich text content as HTML with local image paths
- `solved`: Boolean indicating if this post solved the thread

## Images

All images have been downloaded from Google Cloud Storage and organized locally:

- **User avatars:** `images/users/{user_id}/avatar.{ext}`
- **Post images:** `images/posts/{post_id}/image_{n}.{ext}`
- **Unassigned images:** `images/unassigned/{key}.{ext}` - Images that exist in ActiveStorage but failed to download during normal export

Image paths in `forum_posts.csv` are relative paths from the CSV directory, e.g., `../../images/posts/5/image_1.jpg`

### Unassigned Images

Some images exist in the ActiveStorage database but couldn't be associated with specific users or posts during export. These may be:
- Attachments whose SGID references were broken or corrupted
- Images from deleted posts that still have database records
- Failed rich text associations

All unassigned images are saved in `images/unassigned/` with their GCS key as the filename.
Full metadata (including original filenames, content types, blob IDs, and checksums) is available in `metadata/unassigned_images.json`.

## Notes

- All timestamps are in UTC
- Foreign key relationships are preserved via ID fields
- Rich text HTML has been processed to use local image paths instead of GCS URLs
- Missing or failed downloads are marked with `<img src="MISSING" ...>` tags
- Original ActionText blob SGIDs are mapped in `metadata/attachment_mapping.json`

## Using This Export

### Viewing Content
- CSV files can be opened in Excel, Google Sheets, or any CSV viewer
- JSON files can be parsed by any programming language or JSON viewer
- HTML content in forum_posts can be rendered in a browser
- Images can be viewed directly from the images/ folder

### Re-importing
This export format preserves all foreign key relationships and can be used to:
- Import into a new Rails application
- Migrate to a different database system
- Archive the forum content
- Analyze forum data

## Export Statistics

- Duration: 1m 31s
- Images Downloaded: 3
- Orphaned Images Downloaded: 74
- Images Failed: 5
- Total Records: 474

For detailed logs, see `metadata/export_log.txt`
