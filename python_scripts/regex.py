import re


# this regex finds all tags from a *ML language
all_tags = re.findall(r"((<|<\/)\w+>)", "<div><p>test</p></div><span><:span>")
all_tags = [s[0] for s in all_tags]
print(all_tags)

def get_first_match_from_iterable(iterable):
    # great if you want to search in a very long list (>500 elements)
    return next(
            (value for value in iterable if value[0] > 100),
            None
            )
