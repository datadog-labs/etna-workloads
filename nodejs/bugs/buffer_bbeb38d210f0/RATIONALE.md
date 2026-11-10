# buffer: fix end parameter bugs in indexOf/lastIndexOf

Verbatim tier: the injection is the reverse of the implementation hunks of upstream commit bbeb38d210f051eef6553deb1db4b40ae3e8cae3 applied to v26.13.0 (clean).

Upstream commit message:

```
buffer: fix end parameter bugs in indexOf/lastIndexOf

- Fix FastIndexOfNumber parameter order mismatch (end_i64 and
  is_forward were swapped vs the JS call site and slow path)
- Clamp negative end values to 0 to prevent size_t overflow in
  IndexOfString, IndexOfBuffer, and IndexOfNumberImpl
- Clamp empty needle result to search_end

Signed-off-by: Robert Nagy <ronagy@icloud.com>
Assisted-by: Claude Opus 4.6 (1M context) <noreply@anthropic.com>
PR-URL: https://github.com/nodejs/node/pull/62711
Fixes: https://github.com/nodejs/node/issues/62873
Reviewed-By: Filip Skokan <panva.ip@gmail.com>
Reviewed-By: Yagiz Nizipli <yagiz@nizipli.com>
```
