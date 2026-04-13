## Description
<!-- Describe your changes in detail -->

## Type of Change
<!-- Mark the relevant option with an "x" -->
- [ ] Bug fix (non-breaking change that fixes an issue)
- [ ] New feature (non-breaking change that adds functionality)
- [ ] Breaking change (fix or feature that would cause existing functionality to change)
- [ ] Documentation update
- [ ] Refactoring (no behavior change)

## Related Issues
<!-- Link related issues using # -->
Fixes: #(issue number)
Related to: #(issue number)

## Testing
<!-- Describe the testing approach -->
- [ ] I've added tests for new functionality
- [ ] All existing tests pass
- [ ] I've tested both sync and concurrent scenarios (if applicable)

## Checklist
- [ ] My code follows the style guidelines (run `make lint`)
- [ ] I've auto-formatted my code (run `make format`)
- [ ] I've added/updated tests for my changes
- [ ] All tests pass (`make test`)
- [ ] I've updated documentation (CLAUDE.md) if architectural changes were made
- [ ] I've updated README.md if API changes affect users
- [ ] My commit messages follow the format in CONTRIBUTING.md
- [ ] No merge conflicts with main branch
- [ ] Code coverage is maintained or improved

## Thread-Safety Considerations
<!-- If your changes involve mutable state or concurrency -->
- [ ] Not applicable
- [ ] All mutable state is protected (locks/queues)
- [ ] New Sendable types added (if needed)
- [ ] Concurrent test added to verify safety

## Performance Impact
<!-- Describe any potential performance implications -->
- [ ] No impact
- [ ] Minimal impact: (describe)
- [ ] Needs benchmarking: (describe)

## Additional Notes
<!-- Any additional context for reviewers -->

---

**Checklist for Reviewers:**
- [ ] Changes are focused and follow CONTRIBUTING.md guidelines
- [ ] Thread-safety is properly handled (if applicable)
- [ ] Tests are comprehensive (including concurrent scenarios)
- [ ] Documentation is updated
- [ ] No breaking changes or clearly justified
