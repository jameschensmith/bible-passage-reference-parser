export const bcv_utils = {
	// Make a shallow clone of an object. Nested objects are referenced, not cloned.
	shallow_clone: <T extends {}>(obj: T) => ({ ...obj }),

	// Make a shallow clone of an array. Nested objects are referenced, not cloned.
	shallow_clone_array: <T>(arr: T[]) => [...arr],
};
