
abstract class SubmitFormState {
  const SubmitFormState();
}

class SubmitFormInitial extends SubmitFormState {
  const SubmitFormInitial();
}

class SubmitFormLoading extends SubmitFormState {
  const SubmitFormLoading();
}

class SubmitFormSuccess extends SubmitFormState {
  const SubmitFormSuccess();
}

// ← جديد — حالة خاصة بالتكرار
class SubmitFormDuplicate extends SubmitFormState {
  const SubmitFormDuplicate();
}
class SubmitFormError extends SubmitFormState {
  final String message;
  const SubmitFormError(this.message);
}