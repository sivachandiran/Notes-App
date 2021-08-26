# Notes-App
Description

This task involves building a notes app which allows you to create new notes to keep
track of your tasks!. A note can have a title, body and an optional image. Notes are
displayed in a grid style where the complete title of the note is visible along with its date
of creation.

Clicking on a note, opens a details view which contains the note's body along with an
optional image if it has been added during creation/is available via the API (more on this
later).

Case: A note with an image appears larger in the grid and takes up the full screen width.
Assume Note 3 (Note with the title "10 excellent font pairing tools for designers") in the
below screenshot has an image.

Note: The image within the note detail controller is present only if the note has an
image. Else, the page only shows the note title and the body.

The creation page allows you to create new notes. This page can be opened using the
add floating action button in the bottom right shown in Example Screenshot 1. The
attachment button allows you to select an image from the user's photo library. After
selecting an image. The colour/icon can be changed to green to indicate an attachment
has been selected.

Clicking on save, persists the note on device. Any image attached should be
compressed and be associated with the note being saved.

Note:

● You may use icons required for buttons from external sources which match the
UI sufficiently well.

● Adding Auto Layout constraints programmatically for all UI elements would be
preferred.

● Using an NSFetchedResultsController to display the list of notes in the home
screen would be ideal.

![Screenshot 2021-08-26 at 10 04 14 AM](https://user-images.githubusercontent.com/1251782/130901208-29e8bf74-7f31-497d-a51d-29289b477c12.png)
![Screenshot 2021-08-26 at 10 04 26 AM](https://user-images.githubusercontent.com/1251782/130901215-282d0dac-35f1-43ca-b861-28ff5aa8c0d5.png)
![Screenshot 2021-08-26 at 10 04 37 AM](https://user-images.githubusercontent.com/1251782/130901218-74d45189-f683-49ba-bb06-83ecd7fc1ac4.png)
