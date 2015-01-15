subject: (rappel) Fichier{if:transfer.files>1}s{endif} disponible{if:transfer.files>1}s{endif} au téléchargement

{alternative:plain}

Madame, Monsieur,

Ceci est un rappel.

{if:transfer.files>1}Les fichiers suivants ont été déposés{else}Le fichier suivant a été déposé{endif} sur {cfg:site_name} par {transfer.user_email} et sont disponibles au téléchargement :

{if:transfer.files>1}{each:transfer.files as file}
  - {file.name} ({size:file.size})
{endeach}{else}
{transfer.files.first().name} ({size:transfer.files.first().size})
{endif}

Lien de téléchargement: {cfg:site_url}?s=download&token={recipient.token}

Le dépôt est valable jusqu'au {date:transfer.expires} après quoi il sera supprimé automatiquement.

{if:transfer.message || transfer.subject}
Message de {transfer.user_email}: {transfer.subject}

{transfer.message}
{endif}

Cordialement,
{cfg:site_name}

{alternative:html}

<p>
    Madame, Monsieur,
</p>

<p>
    Ceci est un rappel.
</p>

<p>
    {if:transfer.files>1}Les fichiers suivants ont été déposés{else}Le fichier suivant a été déposé{endif} sur {cfg:site_name} par {transfer.user_email} et sont disponibles au téléchargement :
</p>

<table rules="rows">
    <thead>
        <tr>
            <th colspan="2">Dépôt</th>
        </tr>
    </thead>
    <tbody>
        <tr>
            <td>Fichier{if:transfer.files>1}s{endif}</td>
            <td>
                {if:transfer.files>1}
                <ul>
                    {each:transfer.files as file}
                        <li>{file.name} ({size:file.size})</li>
                    {endeach}
                </ul>
                {else}
                {transfer.files.first().name} ({size:transfer.files.first().size})
                {endif}
            </td>
        </tr>
        {if:transfer.files>1}
        <tr>
            <td>Taille totale</td>
            <td>{size:transfer.size}</td>
        </tr>
        {endif}
        <tr>
            <td>Date d'expiration</td>
            <td>{date:transfer.expires}</td>
        </tr>
        <tr>
            <td>Lien de téléchargement</td>
            <td><a href="{cfg:site_url}?s=download&token={recipient.token}">{cfg:site_url}?s=download&amp;token={recipient.token}</a></td>
        </tr>
    </tbody>
</table>

{if:transfer.message || transfer.subject}
<p>
    Message de {transfer.user_email}: {transfer.subject}
    <br /><br />
    {transfer.message}
</p>
{endif}

<p>
    Cordialement,<br />
    {cfg:site_name}
</p>