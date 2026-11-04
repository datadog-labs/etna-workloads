repro.sql runs INSERTs with a VALUES source: one with too many values for the target column list, and two inserting NULL into a NOT NULL column.
Clean build: planning error "Inconsistent data length across values list..." and "Column 'column1' is declared as non-nullable but contains null values".
Buggy build: "Column count doesn't match insert query!" and "Invalid batch column at '0' has null but schema specifies non-nullable" (Values node nullability/casts not captured at planning).
