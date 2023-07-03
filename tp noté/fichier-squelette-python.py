import re
print(re.match(r'a*(b|ac)+c','aaacc').group())
re.match(r'a*?(b|ac)*c','aaacc').group()
re.match(r'a*(b|ac)*c','aaacc').group()

# a* is greedy by default, and a*? is not
# a* will see 'aaa' (but no match) then 'aa'. for I. In the second case, (b|ac)+ will match 'ac' and c match 'c'
# for II. a*? will see 'a' (but no match) then 'aa', (b|ac)* will see 'b' (neither) then 'ac'. Finally c will be matched.
# for III. a* will see 'aaa' then (b|ac)* have no match, but c will be matched. So 'aaac'

import re
regex_find = r'ab*(bd)+'
motif_replace = r'\1' # no need to escape 'cause it do not need to match, just use the variable
res = re.sub(regex_find,motif_replace,'abbbbbbbbbd')
# res == 'Ceci estres un texte avec une formule stem:[2+3] et aussi stem:[4=8/2]'
print(res)
