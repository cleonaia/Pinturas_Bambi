curl -X POST \
  -H "Accept: application/vnd.github.v3+json" \
  -H "Authorization: token YOUR_TOKEN" \
  https://api.github.com/repos/cleonaia/Pinturas_Bambi/issues \
  -d '{
    "title": "🎨 Improve website design",
    "body": "Enhance the visual design of the website with better colors and typography.",
    "labels": ["enhancement", "design"]
  }'
