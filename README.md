
# wriker
R wrapper for Wrike Project Management API. Package allows enterprise users to
    retreive information on their task, folder, comment, workflow, and custom 
    field data.


## Installation
```
devtools::install_github("aamangold/wriker")
```

## Authentication
### Getting Started

- How to obtain your API key: https://developers.wrike.com/documentation/oauth2
- API developer portal: https://developers.wrike.com


First, follow the instructions in the Wrike developer portal to create a Wrike API App and generate an authentication key. The steps below outline how to store your keys in the .REnviron file. 

### Setting your Wrike authentication key
Note that this package uses Wrike API v3, which will be sunseted 6/30/2019. Package will be updated to v4 in the future.

```
cat("WRIKE_V3_KEY=EnterYourV3KeyHere\n",
    file=file.path(normalizePath("~/"), ".Renviron"),
    append=TRUE)
```
```
cat("WRIKE_V4_KEY=EnterYourV4KeyHere\n",
    file=file.path(normalizePath("~/"), ".Renviron"),
    append=TRUE)
```
Restart R after running. Check that everything loaded properly:
```
Sys.getenv("WRIKE_V3_KEY")
```

### Setting your Wrike account ID
```
wriker::wrike_account_data()
```
Take the id field and set it here:
```
cat("WRIKE_ACCOUNT_ID=EnterYourIDHere\n",
    file=file.path(normalizePath("~/"), ".Renviron"),
    append=TRUE)
```

## Usage

### Query Tasks
#### Pull task data from a specific folder. 
To get more complete information on each's task status, join with workflows.
```
my_folder_tasks <- wriker::wrike_tasks("My Folder Name")
workflows <- wriker::wrike_workflows()

my_folder_tasks %>% 
    dplyr::left_join(workflows, by = "customStatusId")

```

#### Pull task data from multiple folders
```
folders <- c("Folder 1", "Folder 2", "Folder 3")
tasks <- purrr::map_df(folders, wrike_tasks)
```

#### Pull data on a specific task from its ID
```
allfields <- wriker::wrike_task_data("IEABOGRQKQAN3QOA")
specific_fields <- wriker::wrike_task_data("IEABOGRQKQAN3QOA", fields = c("title", "status", "id"))
```


### Custom Fields
#### Find your custom field ID
Each custom field is assigned an ID that can be used to query and update corresponding values. Find a list of all your org's custom fields with corresponding IDs by going to URL from this:
```
wriker::wrike_custom_field_url()
```

#### Create custom field value on Wrike task

```
wriker::wrike_custom_field_update(task_id = "IEABOGRQKQAN3QOA", custom_field_id = "IEAAAOH5JUAAABQ5", 
                                  custom_field_value = "myvalue")

```

#### Create custom field values on multiple Wrike tasks
Create a list with column names of task_id, custom_field_id, and custom_field_value. Then run:
```
my_field_list %>% purrr::pmap(wriker::wrike_custom_field_update)
```


### Comments
You can format your comments using the HTML tags listed [here](https://developers.wrike.com/documentation/api/datatypes/description).

#### Create a comment on a Wrike task
To add a comment on a single task:
```
wriker::create_write_task_comment(task_id = "IEABOGRQKQAN3QOA", comment_text = "19 Years Later")
```

#### Create comments on multiple Wrike tasks
Create a list with the task ids and comments you want to add (column names should be task_id and comment_text). Then run:
```
my_comment_list %>% purrr::pmap(wriker::create_wrike_task_comment)
```
