name: 📋 Pull Request
description: Submit a pull request to improve the project

body:
  - type: markdown
    attributes:
      value: |
        Thanks for contributing to Pinturas Bambi! 🎨

  - type: checkboxes
    id: checklist
    attributes:
      label: Checklist
      description: Please check all that apply
      options:
        - label: I have tested my changes
          required: true
        - label: I have updated documentation if needed
          required: false
        - label: I have added tests if needed
          required: false
        - label: My code follows the project's style guidelines
          required: true

  - type: textarea
    id: description
    attributes:
      label: Description
      description: What does this PR do?
      placeholder: A clear and concise description of your changes
    validations:
      required: true

  - type: textarea
    id: changes
    attributes:
      label: Changes Made
      description: List the specific changes you made
      placeholder: |
        - Added new feature X
        - Fixed bug Y
        - Updated documentation Z
    validations:
      required: true

  - type: textarea
    id: testing
    attributes:
      label: Testing
      description: How did you test your changes?
      placeholder: Describe the testing you performed
    validations:
      required: true
