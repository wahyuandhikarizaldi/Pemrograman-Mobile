## Final Project Notes App (CRUD Firebase, Camera and Gallery, Location)
### Tampilan App
![MergedImages2](https://github.com/wahyuandhikarizaldi/Pemrograman-Mobile/assets/113814423/03e8e2b1-1dbc-44e2-bea2-a2b6b3b74447)

### Widget Variety
![image](https://github.com/wahyuandhikarizaldi/Pemrograman-Mobile/assets/113814423/a1174d3e-eccc-4c0b-bbc3-3c3c95407edf)
- note_edit_widget: Widget ketika menambahkan atau mengupdate note
- note_list_widget: Widget berupa list dari semua note
- note_widget: Widget dari masing-masing note yang tampil di note_list_widget
- upload_task_list_tile_widget: Widget yang berupa status dari suatu task yang tampil di bawah layar

### State Management 
- State Implementation: Menggunakan StatefulWidget dan State Classes di note_edit_widget dan note_list_widget
- State Modification: setState di setiap task seperti ketika memilih gambar, ketika mengambil lokasi, ketika mengupload note, dan ketika refresh note
- UI Interaction: Status dari header Add Note atau Edit Note, lalu gambar yang tampil ketika sudah dipilih, lalu lokasi ketika sudah didapatkan, dan juga status uploading di bawah layar

### Handle Data & Form Validation
- Input Handling: Menggunakan TextField untuk input deskripsi Note, dan ImagePicker untuk memilih gambar.
![image](https://github.com/wahyuandhikarizaldi/Pemrograman-Mobile/assets/113814423/8efef7ad-8b82-46d9-aeda-1351d405b018)

- Form Validation: Validasi ketika deskripsi kosong, akan memunculkan pesan 'Please enter some text'
![image](https://github.com/wahyuandhikarizaldi/Pemrograman-Mobile/assets/113814423/021f595e-920c-45e9-b2c5-532b5d3ef4d1)

- Feedback to User: Status yang muncul di widget yang di bagian bawah layar ketika setiap task CRUD, statusnya antara lain Uploading, Completed, Canceled, Paused, Unknown
![image](https://github.com/wahyuandhikarizaldi/Pemrograman-Mobile/assets/113814423/bb33f40c-14ac-41fe-8105-cc7affbf7876)

### Backend (Menggunakan Firestore dan Firebase Storage) 
- Create: Menambahkan notes baru
- Read: Mengambil notes di dalam database
- Update: Mengupdate atau mengedit notes yang ada di database
- Delete: Menghapus notes di database
  
### CRUD Firebase
![image](https://github.com/wahyuandhikarizaldi/Pemrograman-Mobile/assets/113814423/882f6c34-bf42-44f0-8ade-65ca6a671500)

### Camera and Gallery
![image](https://github.com/wahyuandhikarizaldi/Pemrograman-Mobile/assets/113814423/9afb6873-3675-479a-b254-6443864661c0)
![MergedImages3](https://github.com/wahyuandhikarizaldi/Pemrograman-Mobile/assets/113814423/1b6cbb13-38ab-4d77-b651-1bd1e3efd28b)

### Location
![image](https://github.com/wahyuandhikarizaldi/Pemrograman-Mobile/assets/113814423/90b1f304-a401-4cd0-81d8-821ee57567d9)

### Demo App
Loading...
![New Project (2)](https://github.com/wahyuandhikarizaldi/Pemrograman-Mobile/assets/113814423/5e1bc40f-728e-4206-843f-ae751c34f11e)
