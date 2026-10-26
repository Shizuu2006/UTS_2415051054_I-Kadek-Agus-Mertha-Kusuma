import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../constants.dart';
import '../models/course.dart';
import '../providers/course_provider.dart';
import '../theme.dart';

class CourseFormPage extends StatefulWidget {
  final Course? course;
  const CourseFormPage({super.key, this.course});

  @override
  State<CourseFormPage> createState() => _CourseFormPageState();
}

class _CourseFormPageState extends State<CourseFormPage> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _code;
  late final TextEditingController _title;
  late int _credits;
  late String _status;
  DateTime? _deadline;
  bool _addToCalendar = true;

  bool get _isEdit => widget.course != null;

  @override
  void initState() {
    super.initState();
    final c = widget.course;
    _code = TextEditingController(text: c?.code ?? '');
    _title = TextEditingController(text: c?.title ?? '');
    _credits = c?.credits ?? 3;
    _status = c?.status ?? 'planned';
    _deadline = c?.deadline;
  }

  @override
  void dispose() {
    _code.dispose();
    _title.dispose();
    super.dispose();
  }

  Future<void> _pickDeadline() async {
    final now = DateTime.now();
    final date = await showDatePicker(
      context: context,
      initialDate: _deadline ?? now,
      firstDate: DateTime(now.year - 1),
      lastDate: DateTime(now.year + 5),
    );
    if (date == null || !mounted) return;

    final time = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(_deadline ?? now),
    );
    if (time == null || !mounted) return;

    setState(
      () => _deadline = DateTime(
        date.year,
        date.month,
        date.day,
        time.hour,
        time.minute,
      ),
    );
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    final data = Course(
      code: _code.text.trim(),
      title: _title.text.trim(),
      credits: _credits,
      status: _status,
      deadline: _deadline,
    );
    final provider = context.read<CourseProvider>();

    final ok = _isEdit
        ? await provider.updateCourse(
            widget.course!.id!,
            data,
            addToCalendar: _addToCalendar,
          )
        : await provider.createCourse(data, addToCalendar: _addToCalendar);

    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          ok
              ? (provider.notice ?? 'Tugas berhasil disimpan')
              : 'Gagal menyimpan tugas',
        ),
      ),
    );
    if (ok) Navigator.pop(context, true);
  }

  Widget _label(String text) => Padding(
    padding: const EdgeInsets.only(top: 22, bottom: 10),
    child: Text(
      text,
      style: const TextStyle(
        fontWeight: FontWeight.w600,
        color: AppColors.blue,
      ),
    ),
  );

  Widget _chips<T>({
    required List<T> values,
    required T selected,
    required String Function(T) label,
    required void Function(T) onSelect,
  }) => Wrap(
    spacing: 10,
    children: values
        .map(
          (v) => ChoiceChip(
            label: Text(label(v)),
            selected: selected == v,
            selectedColor: AppColors.blue,
            backgroundColor: AppColors.ice,
            side: BorderSide.none,
            showCheckmark: false,
            labelStyle: TextStyle(
              color: selected == v ? Colors.white : AppColors.navy,
            ),
            onSelected: (_) => setState(() => onSelect(v)),
          ),
        )
        .toList(),
  );

  @override
  Widget build(BuildContext context) {
    final saving = context.watch<CourseProvider>().isSaving;

    return Scaffold(
      appBar: AppBar(),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.fromLTRB(24, 0, 24, 32),
          children: [
            Text(
              _isEdit ? 'Edit Tugas' : 'Tugas Baru',
              style: const TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.bold,
                color: AppColors.navy,
              ),
            ),
            Text(
              '$studentName • $studentNim',
              style: TextStyle(
                fontSize: 12,
                color: AppColors.navy.withValues(alpha: 0.6),
              ),
            ),
            _label('Nama Mata Kuliah'),
            TextFormField(
              controller: _code,
              decoration: const InputDecoration(
                hintText: 'Contoh: Pemrograman Mobile',
              ),
              validator: (v) =>
                  (v == null || v.trim().isEmpty) ? 'Wajib diisi' : null,
            ),
            _label('Judul Tugas'),
            TextFormField(
              controller: _title,
              decoration: const InputDecoration(
                hintText: 'Contoh: Laporan Praktikum',
              ),
              validator: (v) =>
                  (v == null || v.trim().isEmpty) ? 'Wajib diisi' : null,
            ),
            _label('Deadline'),
            InkWell(
              onTap: _pickDeadline,
              borderRadius: BorderRadius.circular(16),
              child: InputDecorator(
                decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.event, color: AppColors.blue),
                  suffixIcon: _deadline == null
                      ? null
                      : IconButton(
                          icon: const Icon(Icons.close),
                          onPressed: () => setState(() => _deadline = null),
                        ),
                ),
                child: Text(
                  _deadline == null
                      ? 'Pilih tanggal & jam'
                      : formatDeadline(_deadline!),
                  style: TextStyle(
                    color: _deadline == null
                        ? AppColors.navy.withValues(alpha: 0.5)
                        : AppColors.navy,
                  ),
                ),
              ),
            ),
            if (_deadline != null) ...[
              const SizedBox(height: 8),
              Text(
                'Pengingat otomatis dikirim 3 hari, 2 hari, dan 1 hari sebelum deadline.',
                style: TextStyle(
                  fontSize: 12,
                  color: AppColors.navy.withValues(alpha: 0.6),
                ),
              ),
              SwitchListTile(
                contentPadding: EdgeInsets.zero,
                activeThumbColor: AppColors.blue,
                title: const Text('Tambahkan ke kalender perangkat'),
                value: _addToCalendar,
                onChanged: (v) => setState(() => _addToCalendar = v),
              ),
            ],
            _label('Prioritas (1-5)'),
            _chips<int>(
              values: const [1, 2, 3, 4, 5],
              selected: _credits,
              label: (v) => '$v',
              onSelect: (v) => _credits = v,
            ),
            _label('Status'),
            _chips<String>(
              values: statuses,
              selected: _status,
              label: statusLabel,
              onSelect: (v) => _status = v,
            ),
            const SizedBox(height: 32),
            FilledButton(
              onPressed: saving ? null : _submit,
              child: saving
                  ? const SizedBox(
                      width: 22,
                      height: 22,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.white,
                      ),
                    )
                  : Text(_isEdit ? 'Simpan Perubahan' : 'Buat Tugas Baru'),
            ),
          ],
        ),
      ),
    );
  }
}
