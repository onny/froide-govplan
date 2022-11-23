# Generated by Django 3.2.12 on 2022-03-14 13:22

from django.db import migrations, models


class Migration(migrations.Migration):

    dependencies = [
        ("froide_govplan", "0006_sections_cms_plugin"),
    ]

    operations = [
        migrations.AlterField(
            model_name="governmentplanscmsplugin",
            name="template",
            field=models.CharField(
                blank=True,
                choices=[
                    ("froide_govplan/plugins/default.html", "Normal"),
                    ("froide_govplan/plugins/progress.html", "Progress"),
                    ("froide_govplan/plugins/card_cols.html", "Card columns"),
                    ("froide_govplan/plugins/search.html", "Search"),
                ],
                help_text="template used to display the plugin",
                max_length=250,
                verbose_name="template",
            ),
        ),
        migrations.AlterField(
            model_name="governmentplanupdate",
            name="url",
            field=models.URLField(blank=True, max_length=1024, verbose_name="URL"),
        ),
    ]
