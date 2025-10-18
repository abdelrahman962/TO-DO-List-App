# Flutter To-Do App

This is a simple **Flutter To-Do app** that uses **SQLite (via sqflite)** to store tasks locally. Users can **add**, **update**, and **delete** tasks, with changes reflected instantly in the app’s interface.

---

## Project Structure

```
lib/
├─ db/
│  └─ tasks_database.dart   # Handles SQLite operations
├─ model/
│  └─ task.dart             # Defines the Task model
└─ home_page.dart           # Main UI of the app
```

---

## Files Overview

### 1. `home_page.dart`

This is the main screen of the app, where users interact with their tasks.

**What it does:**

* Shows a list of tasks using a scrollable `ListView`.
* Lets users add new tasks through a floating action button that opens a dialog.
* Allows marking tasks as completed using a checkbox.
* Enables deleting tasks by long-pressing them.
* Keeps the SQLite database in sync whenever tasks are added, updated, or removed.

**Important Functions:**

* `_tasksList()` → Loads all tasks from the database into the UI.
* `_addTask()` → Adds a new task to the database and updates the list.
* `_updateTask(Task task, int index, bool isChecked)` → Updates a task’s completion status in both the database and UI.
* `_deleteTask(int index)` → Removes a task from the database and the displayed list.

---

### 2. `task.dart`

This file defines the **Task model** and the database table structure.

**What it does:**

* Represents a single task with an `id`, a `description`, and a completion status (`isFinished`).
* Converts tasks to and from database format using `toJson()` and `fromJson()`.
* Allows creating a copy of a task with updated properties using the `copy()` method.

**Notes:**

* `copy()` is handy for creating a new instance of a task when only one property changes (like marking it done).
* `TaskFields` contains the column names for the SQLite database, ensuring consistency.

---

### 3. `tasks_database.dart`

This file handles all interactions with SQLite.

**What it does:**

* Initializes the database and creates the `tasks` table if it doesn’t exist.
* Lets you add new tasks, update existing ones, delete tasks, and fetch all tasks.
* Ensures that all database operations are abstracted away so the UI can simply call functions without writing SQL manually.

**Key Methods:**

* `addNewTask(Task task)` → Adds a task to the database and returns it with its assigned ID.
* `update(Task task)` → Updates an existing task (for example, when a checkbox is toggled).
* `delete(int id)` → Removes a task from the database.
* `getAllTasks()` → Retrieves all tasks to display in the UI.

---


