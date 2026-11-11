Borrowing a null *const () with debug assertions should panic ('null reference produced'); the injected compiler skips the check for ZST pointees so the program exits 0.
